package com.kiendey.utils; // Hoặc package phù hợp với cấu trúc dự án của bạn

import com.kiendey.common.PaymentMethodName; // Đảm bảo import đúng package của enum
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true) // autoApply = true sẽ tự động áp dụng converter này cho tất cả các trường PaymentMethodName
public class PaymentMethodNameConverter implements AttributeConverter<PaymentMethodName, String> {

    @Override
    public String convertToDatabaseColumn(PaymentMethodName attribute) {
        // Lưu trữ displayName vào cơ sở dữ liệu (ví dụ: "Tiền mặt")
        if (attribute == null) {
            return null;
        }
        return attribute.getDisplayName();
    }

    @Override
    public PaymentMethodName convertToEntityAttribute(String dbData) {
        // Chuyển đổi chuỗi từ DB (ví dụ: "Tiền mặt") thành enum
        // Sử dụng phương thức fromDisplayName đã thêm vào enum
        if (dbData == null || dbData.trim().isEmpty()) {
            return null;
        }
        try {
            return PaymentMethodName.fromDisplayName(dbData);
        } catch (IllegalArgumentException e) {
            // Xử lý trường hợp không mong muốn, ví dụ log lỗi hoặc ném một exception khác cụ thể hơn
            System.err.println("Lỗi khi chuyển đổi giá trị từ DB '" + dbData + "' sang enum PaymentMethodName: " + e.getMessage());
            // Bạn có thể chọn ném lại lỗi hoặc trả về null/giá trị mặc định tùy theo yêu cầu
            throw e;
        }
    }
}