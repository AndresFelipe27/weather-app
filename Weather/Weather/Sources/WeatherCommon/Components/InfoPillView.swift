//
//  InfoPillView.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct InfoPillView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: .layoutSize11, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, .layoutSize10)
            .padding(.vertical, .layoutSize6)
            .background(
                Capsule().fill(Color.white.opacity(0.18))
            )
    }
}
