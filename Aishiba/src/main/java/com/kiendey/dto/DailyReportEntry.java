package com.kiendey.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DailyReportEntry {
    private String invoiceCode;
    private String customerName;
    private String employeeName;
    private String time; // Formatted time string
    private double totalItemsAmount;
    private double revenue;
    private double vat;
}