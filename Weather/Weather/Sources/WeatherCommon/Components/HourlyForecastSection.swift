//
//  HourlyForecastSection.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct HourlyForecastSection: View {
    let hours: [HourForecast]

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing12) {
            Text(L10n.next24Hours)
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .spacing12) {
                    ForEach(hours.prefix(24), id: \.time) { hour in
                        HourForecastCell(hour: hour)
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .padding(.spacing16)
        .background(CardBackground())
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius16))
    }
}

private struct HourForecastCell: View {
    let hour: HourForecast

    var body: some View {
        VStack(spacing: 8) {
            Text(hour.displayHour)
                .font(.caption)
                .opacity(0.8)

            CachedRemoteImage(urlString: hour.condition.iconPath)
                .frame(width: .iconSize28, height: .iconSize28)

            Text("\(format(hour.tempC))°")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(width: .hourCellWidth, height: .hourCellHeight)
        .background(SecondaryCardBackground())
        .clipShape(RoundedRectangle(cornerRadius: 14))
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
    static let hourCellWidth: CGFloat = 74
    static let hourCellHeight: CGFloat = 92
}
