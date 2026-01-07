//
//  SearchLoadingView.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct SearchLoadingView: View {
    var body: some View {
        VStack(spacing: .layoutSize12) {
            ProgressView()
            Text("Searching…")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
