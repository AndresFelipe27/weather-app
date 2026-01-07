//
//  SearchView.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct SearchView<ViewModel>: View where ViewModel: SearchViewModelProtocol {
    @StateObject private var viewModel: ViewModel

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        VStack(spacing: .layoutSize16) {
            header

            WeatherSearchBar(
                text: $viewModel.query,
                placeholder: L10n.searchForACity
            )

            content
        }
        .padding(.horizontal, .layoutSize16)
        .padding(.top, .layoutSize8)
        .background(Color.searchBackground.ignoresSafeArea())
        .onAppear(perform: viewModel.onAppear)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .interactiveDismissDisabled(true)
    }

    private var header: some View {
        HStack {
            Text(L10n.weather)
                .font(.system(size: .layoutSize26, weight: .semibold))

            Spacer()

            Button(action: viewModel.onTapFavorites) {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: .layoutSize18, weight: .semibold))
                    .foregroundStyle(Color.blue)
                    .padding(.layoutSize10)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .shadow(radius: .layoutSize6)
                    )
            }
            .accessibilityLabel("Favorites")
        }
        .padding(.top, .layoutSize4)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .idle:
            SearchEmptyStateView(
                title: L10n.searchALocation,
                subtitle: L10n.typeACityNameToSeeSuggestionsInstantly
            )

        case .loading:
            SearchLoadingView()

        case .empty:
            SearchEmptyStateView(
                title: L10n.noResults,
                subtitle: L10n.tryAnotherCityName
            )

        case .error:
            SearchErrorStateView(
                title: L10n.somethingWentWrong,
                subtitle: viewModel.errorMessage ?? L10n.pleaseTryAgain
            )

        case .loaded:
            LocationResultsGrid(
                locations: viewModel.locations,
                onTap: viewModel.onTapLocation
            )
        }
    }
}

private extension Color {
    static let searchBackground: Color = Color(.systemGroupedBackground)
}
