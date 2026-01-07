//
//  DaysForecastSection.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct DaysForecastSection: View {
    let days: [ForecastDay]

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing12) {
            Text(L10n.next3Days)
                .font(.headline)

            VStack(spacing: .spacing12) {
                ForEach(days, id: \.date) { day in
                    DayForecastRow(day: day)
                }
            }
        }
        .padding(.spacing16)
        .background(CardBackground())
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius16))
    }
}

private struct DayForecastRow: View {
    let day: ForecastDay

    var body: some View {
        HStack(spacing: .spacing12) {
            Text(day.date)
                .font(.subheadline)
                .frame(width: 90, alignment: .leading)

            CachedRemoteImage(urlString: day.day.condition.iconPath)
                .frame(width: .iconSize28, height: .iconSize28)

            VStack(alignment: .leading, spacing: 2) {
                Text(day.day.condition.text)
                    .font(.subheadline)

                Text("Avg \(format(day.day.avgTempC))°C")
                    .font(.caption)
                    .opacity(0.75)
            }

            Spacer()

            Text("\(format(day.day.maxTempC))° / \(format(day.day.minTempC))°")
                .font(.subheadline)
                .opacity(0.9)
        }
    }

    private func format(_ value: Double) -> String {
        String(format: "%.0f", value)
    }
}

private extension CGFloat {
    static let spacing12: CGFloat = 12
    static let spacing16: CGFloat = 16
    static let cornerRadius16: CGFloat = 16
    static let iconSize28: CGFloat = 28
}
