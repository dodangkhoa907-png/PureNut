package com.purenut.shop.model;

import java.util.Date;

public class DealerLead {
    private int leadId;
    private String fullName;
    private String phone;
    private String email;
    private String city;
    private String status;
    private Date createdAt;

    public DealerLead() {}

    public DealerLead(String fullName, String phone, String email, String city) {
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.city = city;
        this.status = "PENDING";
    }

    public int getLeadId() { return leadId; }
    public void setLeadId(int leadId) { this.leadId = leadId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
