package com.kiendey.dto;

import com.kiendey.utils.StringFormatUtil;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductSaleStat {
    private String toyId;
    private String toyName;
    private long quantitySold;

    // Constructor for HQL query
    public ProductSaleStat(String toyId, String toyName, Long quantitySold) {
        this.toyId = toyId;
        this.toyName = toyName;
        this.quantitySold = quantitySold != null ? quantitySold : 0L;
    }

    public String getFormattedIdDisplay() {
        if (this.getToyId() != null && this.getToyId().length() >= 8) {
            return "TOY" + this.getToyId().substring(0, 4).toUpperCase();
        }
        return "TOY-N/A"; // Hoặc một giá trị mặc định khác nếu id không hợp lệ
    }

    /**
     * Trả về tên sản phẩm đã được định dạng (Title Case).
     */
    public String getFormattedToyName() {
        return StringFormatUtil.toTitleCase(this.toyName);
    }
}