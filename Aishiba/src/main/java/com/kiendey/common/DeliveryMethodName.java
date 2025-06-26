package com.kiendey.common;

import lombok.Getter;

@Getter
public enum DeliveryMethodName {

    Tiêu_chuẩn("Tiêu chuẩn"),        // Giao hàng tiêu chuẩn
    Nhanh("Nhanh"),              // Giao hàng nhanh
    Hỏa_tốc("Hỏa tốc"),        // Giao hàng trong ngày
    Lấy_tại_cửa_hàng("Lấy tại cửa hàng"); // Nhận hàng tại cửa hàng
    private final String displayName;

    DeliveryMethodName(String displayName) {
        this.displayName = displayName;
    }

    /**
     * Tìm hằng số enum DeliveryMethodName từ displayName.
     * @param displayNameToFind Tên hiển thị để tìm kiếm.
     * @return Hằng số enum tương ứng, hoặc ném IllegalArgumentException nếu không tìm thấy.
     */
    public static DeliveryMethodName fromDisplayName(String displayNameToFind) {
        if (displayNameToFind == null || displayNameToFind.trim().isEmpty()) {
            return null; // Hoặc ném lỗi tùy theo logic của bạn
        }
        String trimmedDisplayName = displayNameToFind.trim();
        for (DeliveryMethodName dm : values()) {
            if (dm.getDisplayName().equalsIgnoreCase(trimmedDisplayName)) {
                return dm;
            }
        }
        // Fallback: thử thay thế dấu cách bằng dấu gạch dưới để khớp với tên hằng số
        String normalizedName = trimmedDisplayName.replace(" ", "_");
        try {
            return DeliveryMethodName.valueOf(normalizedName);
        } catch (IllegalArgumentException e) {
            System.err.println("Không thể tìm thấy DeliveryMethodName cho giá trị: '" + displayNameToFind + "'");
            throw new IllegalArgumentException("Không tìm thấy phương thức giao hàng nào với tên: '" + displayNameToFind + "'");
        }
    }
}
