//
//  CardBackground.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct CardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.white.opacity(0.08))
            )
    }
}

struct SecondaryCardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(Color.white.opacity(0.06))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.white.opacity(0.06))
            )
    }
}

struct LinearGradientBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(0.85),
                Color.black.opacity(0.65),
                Color.black.opacity(0.85)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
