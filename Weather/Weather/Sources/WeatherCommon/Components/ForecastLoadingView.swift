//
//  ForecastLoadingView.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct ForecastLoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading forecast...")
                .font(.subheadline)
                .opacity(0.8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ForecastErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title)

            Text("Something went wrong")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .opacity(0.8)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
