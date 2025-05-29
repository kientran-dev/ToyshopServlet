package com.kiendey.utils;

import java.util.Objects;

public class StringFormatUtil {

    /**
     * Chuyển đổi một chuỗi sang dạng Title Case (viết hoa chữ cái đầu mỗi từ).
     * Xử lý null, chuỗi rỗng, và các khoảng trắng thừa.
     * @param input Chuỗi đầu vào.
     * @return Chuỗi đã được định dạng Title Case, hoặc chuỗi rỗng nếu input là null/rỗng.
     */
    public static String toTitleCase(String input) {
        if (input == null || input.trim().isEmpty()) {
            return "";
        }

        // Chuẩn hóa chuỗi và cắt theo dấu phân cách mô tả
        String normalized = input.trim().replaceAll("\\s+", " ");
        String[] parts = normalized.split(" - | \\| ");
        String base = parts[0];

        // Tách từng từ và viết hoa chữ cái đầu
        StringBuilder titleCase = new StringBuilder();
        for (String word : base.split(" ")) {
            if (!word.isEmpty()) {
                int firstCodePoint = word.codePointAt(0);
                int firstCharLen = Character.charCount(firstCodePoint);
                String first = new String(Character.toChars(Character.toTitleCase(firstCodePoint)));
                String rest = word.substring(firstCharLen).toLowerCase();
                titleCase.append(first).append(rest).append(" ");
            }
        }

        String formatted = titleCase.toString().trim();

        // Giới hạn độ dài nếu cần (ví dụ 30 ký tự)
        int maxLength = 30;
        if (formatted.length() > maxLength) {
            return formatted.substring(0, maxLength - 3).trim() + "...";
        }

        return formatted;
    }

    // Bạn có thể thêm các hàm định dạng chuỗi khác vào đây trong tương lai
}