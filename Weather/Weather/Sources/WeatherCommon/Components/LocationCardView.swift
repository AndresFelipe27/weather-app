//
//  LocationCardView.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct LocationCardView: View {
    let location: Location
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: .layoutSize18)
                    .fill(gradient(for: location.id))
                    .frame(height: .cardHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: .layoutSize18)
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: .layoutSize8) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: .layoutSize4) {
                            Text(location.name)
                                .font(.system(size: .layoutSize20, weight: .semibold))
                                .foregroundStyle(.white)
                                .lineLimit(1)

                            Text(location.country)
                                .font(.system(size: .layoutSize14, weight: .medium))
                                .foregroundStyle(.white.opacity(0.9))
                                .lineLimit(1)
                        }

                        Spacer()

                        Image(systemName: "location.fill")
                            .foregroundStyle(.white.opacity(0.9))
                    }

                    Text(location.region)
                        .font(.system(size: .layoutSize12))
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(2)

                    HStack(spacing: .layoutSize6) {
                        InfoPillView(text: "Lat \(location.latitude.formatted(.number.precision(.fractionLength(2))))")
                        InfoPillView(text: "Lon \(location.longitude.formatted(.number.precision(.fractionLength(2))))")
                    }
                }
                .padding(.layoutSize14)

                Image(systemName: "chevron.right")
                    .font(.system(size: .layoutSize16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.layoutSize14)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(location.name), \(location.country)")
    }

    private func gradient(for id: Int) -> LinearGradient {
        let palette = GradientPalette.palette(for: id)
        return LinearGradient(colors: palette, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

private extension CGFloat {
    static let cardHeight: CGFloat = 150
}

private enum GradientPalette {
    static func palette(for id: Int) -> [Color] {
        let palettes: [[Color]] = [
            [Color.blue.opacity(0.85), Color.cyan.opacity(0.8)],
            [Color.purple.opacity(0.85), Color.indigo.opacity(0.85)],
            [Color.orange.opacity(0.9), Color.yellow.opacity(0.8)],
            [Color.teal.opacity(0.85), Color.blue.opacity(0.85)]
        ]
        let index = abs(id) % palettes.count
        return palettes[index]
    }
}
