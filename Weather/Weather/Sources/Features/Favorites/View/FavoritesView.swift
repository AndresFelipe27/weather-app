//
//  FavoritesView.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct FavoritesView<ViewModel>: View where ViewModel: FavoritesViewModelProtocol {
    @StateObject private var viewModel: ViewModel

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        GeometryReader { proxy in
            let isLandscape = proxy.size.width > proxy.size.height

            Group {
                if viewModel.favorites.isEmpty {
                    emptyState
                } else if isLandscape {
                    gridContent
                } else {
                    listContent
                }
            }
            .navigationTitle(L10n.favoritesTitle)
            .onAppear { viewModel.onAppear() }
        }
    }

    private var listContent: some View {
        List(viewModel.favorites, id: \.id) { location in
            Button {
                viewModel.onTapLocation(location)
            } label: {
                FavoriteLocationRow(location: location)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
    }

    private var gridContent: some View {
        ScrollView {
            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 12) {
                ForEach(viewModel.favorites, id: \.id) { location in
                    Button {
                        viewModel.onTapLocation(location)
                    } label: {
                        FavoriteLocationCard(location: location)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "star")
                .font(.system(size: 42))
                .opacity(0.8)
            Text(L10n.noFavoritesYet)
                .font(.headline)
            Text(L10n.markLocationsAsFavoritesFromTheForecastScreen)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .opacity(0.7)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct FavoriteLocationRow: View {
    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.headline)

            Text("\(location.region), \(location.country)")
                .font(.subheadline)
                .opacity(0.7)
        }
        .padding(.vertical, 6)
    }
}

private struct FavoriteLocationCard: View {
    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(location.name)
                .font(.headline)

            Text("\(location.region), \(location.country)")
                .font(.subheadline)
                .opacity(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
