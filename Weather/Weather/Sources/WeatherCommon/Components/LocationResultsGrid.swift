//
//  LocationResultsGrid.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct LocationResultsGrid: View {
    let locations: [Location]
    let onTap: (Location) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: .layoutSize14) {
                ForEach(locations) { location in
                    LocationCardView(location: location) {
                        onTap(location)
                    }
                }
            }
            .padding(.vertical, .layoutSize12)
        }
    }

    private var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: .gridMinWidth), spacing: .layoutSize14)
        ]
    }
}

private extension CGFloat {
    static let gridMinWidth: CGFloat = 260
}
