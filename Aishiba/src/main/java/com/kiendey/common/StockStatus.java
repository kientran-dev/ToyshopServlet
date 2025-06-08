package com.kiendey.common;

import lombok.Getter;

@Getter
public enum StockStatus {
    CHO_XU_LY("Chờ xử lý"),
    DA_THANH_TOAN( "Đã thanh toán"),
    DANG_GIAO_HANG("Đang giao hàng"),
    DA_HUY("Đã hủy");

    private final String displayName;

    StockStatus(String displayName) {
        this.displayName = displayName;
    }
}
