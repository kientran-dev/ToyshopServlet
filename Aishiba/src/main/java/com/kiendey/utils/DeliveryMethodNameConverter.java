package com.kiendey.utils;

import com.kiendey.common.DeliveryMethodName; // Import enum DeliveryMethodName
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true) // Tự động áp dụng cho các trường DeliveryMethodName
public class DeliveryMethodNameConverter implements AttributeConverter<DeliveryMethodName, String> {

    @Override
    public String convertToDatabaseColumn(DeliveryMethodName attribute) {
        // Lưu trữ displayName vào cơ sở dữ liệu (ví dụ: "Tiêu chuẩn")
        if (attribute == null) {
            return null;
        }
        return attribute.getDisplayName();
    }

    @Override
    public DeliveryMethodName convertToEntityAttribute(String dbData) {
        // Chuyển đổi chuỗi từ DB (ví dụ: "Tiêu chuẩn") thành enum
        if (dbData == null || dbData.trim().isEmpty()) {
            return null;
        }
        try {
            return DeliveryMethodName.fromDisplayName(dbData);
        } catch (IllegalArgumentException e) {
            System.err.println("Giá trị không hợp lệ từ DB cho DeliveryMethodName: '" + dbData + "'. " + e.getMessage());
            throw e;
        }
    }
}

