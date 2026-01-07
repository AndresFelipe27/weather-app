//
//  SearchErrorStateView.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct SearchErrorStateView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: .layoutSize12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: .layoutSize44))
                .foregroundStyle(.orange)

            Text(title)
                .font(.system(size: .layoutSize18, weight: .semibold))

            Text(subtitle)
                .font(.system(size: .layoutSize14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .layoutSize24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
