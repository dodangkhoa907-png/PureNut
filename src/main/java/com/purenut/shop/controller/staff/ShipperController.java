package com.purenut.shop.controller.staff;

import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.ShipperDao;
import com.purenut.shop.dao.impl.OrderDaoImpl;
import com.purenut.shop.dao.impl.ShipperDaoImpl;
import com.purenut.shop.model.Order;
import com.purenut.shop.model.Shipper;
import com.purenut.shop.model.User;
import com.purenut.shop.util.AuditLogger;
import com.purenut.shop.util.Validators;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

/**
 * Khu làm việc Shipper (mobile-first):
 *  GET  /shipper                 → danh sách đơn được gán (ưu tiên đơn đang chạy)
 *  POST /shipper/cap-nhat        → state machine: ASSIGNED → PICKING_UP → DELIVERING → COMPLETED / FAILED
 *  POST /shipper/proof           → upload ảnh bằng chứng giao hàng (bắt buộc trước COMPLETED)
 *  POST /shipper/trang-thai      → shipper bật/tắt ACTIVE ↔ OFFLINE
 *
 * BẢO MẬT NHIỀU LỚP:
 *  1. AuthFilter    — phải đăng nhập đúng role SHIPPER
 *  2. ShipperIpFilter — IP phải nằm trong whitelist nội bộ (Shippers.Allowed_IP)
 *  3. CsrfFilter    — mọi POST phải kèm token
 *  4. CAS trong SQL — WHERE ShipperID = tôi AND DeliveryStatus = trạng-thái-nguồn
 *                     (không nhảy cóc, không cướp đơn người khác, không double-submit)
 */
@WebServlet(name = "ShipperController", urlPatterns = {
        "/shipper", "/shipper/cap-nhat", "/shipper/proof", "/shipper/trang-thai"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 8 * 1024 * 1024, fileSizeThreshold = 1024 * 1024)
public class ShipperController extends HttpServlet {

    /** Luồng 1 chiều — mỗi trạng thái chỉ có đúng các bước kế tiếp hợp lệ */
    private static final Map<String, Set<String>> NEXT = Map.of(
            "ASSIGNED",   Set.of("PICKING_UP"),
            "PICKING_UP", Set.of("DELIVERING", "FAILED"),
            "DELIVERING", Set.of("COMPLETED", "FAILED")
    );

    private static final Set<String> ALLOWED_IMG_TYPES =
            Set.of("image/jpeg", "image/png", "image/webp");

    private OrderDao orderDao;
    private ShipperDao shipperDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
        shipperDao = new ShipperDaoImpl();
    }

    private User currentShipper(HttpServletRequest req) {
        User u = (User) req.getSession().getAttribute("shipperUser");
        if (u != null && "SHIPPER".equals(u.getRole())) return u;
        return (User) req.getSession().getAttribute("adminUser"); // admin giám sát
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User shipper = currentShipper(req);
        if (shipper == null) { resp.sendRedirect(req.getContextPath() + "/shipper/login"); return; }

        // Hồ sơ shipper: tự tạo nếu chưa có (user mới lên role sau migration)
        shipperDao.ensureProfile(shipper.getUserId(), shipper.getFullName(), shipper.getPhone());
        Shipper profile = shipperDao.findById(shipper.getUserId()).orElse(null);

        List<Order> orders = orderDao.findOrdersByShipper(shipper.getUserId());
        long active = orders.stream().filter(o ->
                o.getDeliveryStatus() != null &&
                Set.of("ASSIGNED", "PICKING_UP", "DELIVERING").contains(o.getDeliveryStatus())).count();
        long done = orders.stream().filter(o -> "COMPLETED".equals(o.getDeliveryStatus())).count();

        req.setAttribute("orders", orders);
        req.setAttribute("profile", profile);
        req.setAttribute("activeCount", active);
        req.setAttribute("doneCount", done);
        req.getRequestDispatcher("/WEB-INF/views/staff/shipper.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User shipper = currentShipper(req);
        if (shipper == null) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        switch (req.getServletPath()) {
            case "/shipper/cap-nhat"   -> handleStateTransition(req, resp, shipper);
            case "/shipper/proof"      -> handleProofUpload(req, resp, shipper);
            case "/shipper/trang-thai" -> handleToggleStatus(req, resp, shipper);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /* ---------- State machine: 1 chiều, không nhảy cóc ---------- */
    private void handleStateTransition(HttpServletRequest req, HttpServletResponse resp, User shipper)
            throws IOException {
        int orderId  = Validators.parsePositiveInt(req.getParameter("orderId"), -1);
        String from  = req.getParameter("from");
        String to    = req.getParameter("to");

        if (orderId <= 0 || from == null || to == null) {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Dữ liệu không hợp lệ\"}"); return;
        }

        // Kiểm tra luồng hợp lệ TRƯỚC khi chạm DB
        Set<String> allowedNext = NEXT.get(from);
        if (allowedNext == null || !allowedNext.contains(to)) {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Không thể chuyển " + esc(from) + " → " + esc(to) + ". Luồng: Nhận đơn → Lấy hàng → Đang giao → Hoàn thành.\"}");
            return;
        }

        // COMPLETED bắt buộc có ảnh bằng chứng
        if ("COMPLETED".equals(to)) {
            Order order = orderDao.findOrderById(orderId);
            if (order == null || order.getProofImage() == null || order.getProofImage().isBlank()) {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Chụp ảnh xác nhận giao hàng trước khi chốt đơn!\",\"needProof\":true}");
                return;
            }
        }

        // CAS atomic trong SQL — thất bại nếu đơn không thuộc mình hoặc trạng thái đã đổi
        int n = orderDao.updateDeliveryStatus(orderId, shipper.getUserId(), from, to);
        if (n > 0) {
            AuditLogger.log(req, shipper.getUserId(), "DELIVERY_" + to,
                    "Đơn #" + orderId, "Shipper chuyển " + from + " → " + to);
            writeJson(resp, "{\"ok\":true,\"status\":\"" + to + "\"}");
        } else {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Đơn không thuộc quyền xử lý hoặc trạng thái đã thay đổi. Tải lại trang.\"}");
        }
    }

    /* ---------- Upload ảnh bằng chứng (camera capture) ---------- */
    private void handleProofUpload(HttpServletRequest req, HttpServletResponse resp, User shipper)
            throws IOException {
        int orderId = Validators.parsePositiveInt(req.getParameter("orderId"), -1);
        if (orderId <= 0) { writeJson(resp, "{\"ok\":false,\"msg\":\"Đơn không hợp lệ\"}"); return; }

        Part filePart;
        try {
            filePart = req.getPart("proofImage");
        } catch (ServletException e) {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Ảnh quá lớn (tối đa 5MB)\"}"); return;
        }
        if (filePart == null || filePart.getSize() == 0) {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Chưa chọn ảnh\"}"); return;
        }
        String contentType = filePart.getContentType();
        if (!ALLOWED_IMG_TYPES.contains(contentType)) {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Chỉ nhận ảnh JPG/PNG/WebP\"}"); return;
        }

        String ext = switch (contentType) {
            case "image/png"  -> ".png";
            case "image/webp" -> ".webp";
            default           -> ".jpg";
        };
        String fileName = "proof_" + orderId + "_" + UUID.randomUUID().toString().substring(0, 8) + ext;
        String uploadDir = req.getServletContext().getRealPath("/resources/img/proof");
        Path dir = Paths.get(uploadDir);
        Files.createDirectories(dir);
        try (var in = filePart.getInputStream()) {
            Files.copy(in, dir.resolve(fileName));
        }

        String webPath = "/resources/img/proof/" + fileName;
        // Chỉ chủ đơn + đơn đang DELIVERING mới lưu được (khóa trong SQL)
        int n = orderDao.setProofImage(orderId, shipper.getUserId(), webPath);
        if (n > 0) {
            AuditLogger.log(req, shipper.getUserId(), "DELIVERY_PROOF",
                    "Đơn #" + orderId, "Upload ảnh bằng chứng " + fileName);
            writeJson(resp, "{\"ok\":true,\"path\":\"" + esc(webPath) + "\"}");
        } else {
            Files.deleteIfExists(dir.resolve(fileName)); // rollback file mồ côi
            writeJson(resp, "{\"ok\":false,\"msg\":\"Đơn chưa ở trạng thái Đang giao hoặc không thuộc bạn\"}");
        }
    }

    /* ---------- Shipper bật/tắt nhận đơn ---------- */
    private void handleToggleStatus(HttpServletRequest req, HttpServletResponse resp, User shipper)
            throws IOException {
        String status = req.getParameter("status");
        boolean ok = shipperDao.updateStatus(shipper.getUserId(), status);
        writeJson(resp, ok ? "{\"ok\":true}" : "{\"ok\":false,\"msg\":\"Trạng thái không hợp lệ\"}");
    }

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("<", "\\u003c").replace(">", "\\u003e");
    }

    private void writeJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) { out.print(json); }
    }
}
