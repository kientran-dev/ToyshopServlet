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
public class DailyReportSummary {
    private double totalAllItemsAmount;
    private double totalAllRevenue;
    private double totalAllVat;
}