//
//  WeatherSearchBar.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct WeatherSearchBar: View {
    @Binding private var text: String
    private let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }

    var body: some View {
        HStack(spacing: .layoutSize10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.secondary)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
                .submitLabel(.search)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.secondary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, .layoutSize14)
        .padding(.vertical, .layoutSize12)
        .background(
            RoundedRectangle(cornerRadius: .layoutSize14)
                .fill(Color.white)
                .shadow(radius: .layoutSize6)
        )
    }
}
