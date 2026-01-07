//
//  CurrentForecastCard.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct CurrentForecastCard: View {
    let current: CurrentWeather
    let location: ForecastLocation

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing16) {
            HStack(alignment: .center, spacing: .spacing16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(location.name), \(location.country)")
                        .font(.headline)

                    Text(location.localtime)
                        .font(.caption)
                        .opacity(0.7)
                }

                Spacer()

                CachedRemoteImage(urlString: current.condition.iconPath)
                    .frame(width: .iconSize44, height: .iconSize44)
            }

            HStack(alignment: .bottom) {
                Text("\(format(current.tempC))°")
                    .font(.system(size: 56, weight: .bold))

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(current.condition.text)
                        .font(.headline)

                    Text("\(L10n.feelsLike) \(format(current.feelsLikeC))°")
                        .font(.subheadline)
                        .opacity(0.8)
                }
            }

            MetricsRow(metrics: [
                .init(title: L10n.humidity, value: "\(current.humidity)%", systemImage: "drop.fill"),
                .init(title: L10n.wind, value: "\(format(current.windKph)) km/h", systemImage: "wind"),
                .init(title: L10n.uv, value: "\(format(current.ultravioletIndex))", systemImage: "sun.max.fill")
            ])
        }
        .padding(.spacing16)
        .background(CardBackground())
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius16))
    }

    private func format(_ value: Double) -> String {
        String(format: "%.0f", value)
    }
}

private extension CGFloat {
    static let spacing16: CGFloat = 16
    static let cornerRadius16: CGFloat = 16
    static let iconSize44: CGFloat = 44
}
