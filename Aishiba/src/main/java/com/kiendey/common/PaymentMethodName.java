package com.kiendey.common;

import lombok.Getter;

@Getter
public enum PaymentMethodName {
    Thẻ_tín_dụng("Thẻ tín dụng"),
    Thẻ_ghi_nợ("Thẻ ghi nợ"),
    Chuyển_khoản_ngân_hàng("Chuyển khoản ngân hàng"),
    Tiền_mặt("Tiền mặt"); // Hằng số: Tiền_mặt, displayName: "Tiền mặt"

    private final String displayName;

    PaymentMethodName(String displayName) {
        this.displayName = displayName;
    }

    /**
     * Tìm hằng số enum PaymentMethodName từ displayName.
     * @param displayNameToFind Tên hiển thị để tìm kiếm.
     * @return Hằng số enum tương ứng, hoặc ném IllegalArgumentException nếu không tìm thấy.
     */
    public static PaymentMethodName fromDisplayName(String displayNameToFind) {
        if (displayNameToFind == null || displayNameToFind.trim().isEmpty()) {
            return null; // Hoặc ném lỗi tùy theo logic của bạn
        }
        for (PaymentMethodName pm : values()) {
            if (pm.getDisplayName().equalsIgnoreCase(displayNameToFind.trim())) {
                return pm;
            }
        }
        // Fallback: thử thay thế dấu cách bằng dấu gạch dưới để khớp với tên hằng số
        String normalizedName = displayNameToFind.trim().replace(" ", "_");
        try {
            return PaymentMethodName.valueOf(normalizedName);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Không tìm thấy phương thức thanh toán nào cho giá trị: '" + displayNameToFind + "'");
        }
    }
}