package com.kiendey.dto;

import com.kiendey.utils.StringFormatUtil;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class StockProductStat {
    private String toyId;
    private String toyName;
    private int quantity; // Thêm trường quantity vào đây

    /**
     * Trả về ID sản phẩm đã được định dạng (TOYxxxx).\r\n
     */
    public String getFormattedIdDisplay() {
        if (this.toyId != null && this.toyId.length() >= 8) {
            return "TOY" + this.toyId.substring(0, 4).toUpperCase();
        }
        return "TOY-N/A";
    }

    /**
     * Trả về tên sản phẩm đã được định dạng (Title Case).\r\n
     */
    public String getFormattedToyName() {
        return StringFormatUtil.toTitleCase(this.toyName);
    }
}