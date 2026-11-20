package model;

// Lop thuc the Customer4 - khach hang, ke thua Member4.
// Ho ten, so dien thoai, email nam o lop cha Member4 (bang tblMember4);
// bang tblCustomer4 chi giu id va customerCode.
public class Customer4 extends Member4 {
    private String customerCode;

    public Customer4() { }

    public String getCustomerCode() { return customerCode; }
    public void setCustomerCode(String customerCode) { this.customerCode = customerCode; }
}
