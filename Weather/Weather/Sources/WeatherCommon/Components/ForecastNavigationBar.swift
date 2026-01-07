//
//  ForecastNavigationBar.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct ForecastNavigationBar: View {
    let title: String
    let isFavorite: Bool
    let onBack: () -> Void
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: .spacing12) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text("Forecast")
                    .font(.caption)
                    .opacity(0.7)
            }

            Spacer()

            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .font(.headline)
            }
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
        }
        .padding(.top, .spacing12)
    }
}

private extension CGFloat {
    static let spacing12: CGFloat = 12
}
