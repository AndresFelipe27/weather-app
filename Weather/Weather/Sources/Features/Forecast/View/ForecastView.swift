//
//  ForecastView.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct ForecastView<ViewModel>: View where ViewModel: ForecastViewModelProtocol {
    @StateObject private var viewModel: ViewModel

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        GeometryReader { proxy in
            let isLandscape = proxy.size.width > proxy.size.height

            content(isLandscape: isLandscape)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.25),
                            Color.purple.opacity(0.20)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                )
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
    }

    @ViewBuilder
    private func content(isLandscape: Bool) -> some View {
        VStack(spacing: .spacing16) {
            ForecastNavigationBar(
                title: viewModel.title,
                isFavorite: viewModel.isFavorite,
                onBack: viewModel.onTapBack,
                onToggleFavorite: viewModel.onToggleFavorite
            )

            switch viewModel.state {
            case .idle, .loading:
                ForecastLoadingView()

            case .error(let message):
                ForecastErrorView(message: message)

            case .loaded(let forecast):
                if isLandscape {
                    ForecastLandscapeLayout(forecast: forecast)
                } else {
                    ForecastPortraitLayout(forecast: forecast)
                }
            }
        }
        .padding(.horizontal, .spacing16)
        .padding(.bottom, .spacing16)
    }
}

private struct ForecastPortraitLayout: View {
    let forecast: WeatherForecast

    var body: some View {
        ScrollView {
            VStack(spacing: .spacing16) {
                CurrentForecastCard(current: forecast.current, location: forecast.location)
                    .padding(.horizontal, 0)
                    .background(
                        RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                            .fill(
                                LinearGradient(colors: [Color.blue.opacity(0.85), Color.purple.opacity(0.85)],
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)

                DaysForecastSection(days: forecast.forecastDays.prefix(Int.forecastDays).map { $0 })
                    .padding(.horizontal, 0)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                            .fill(
                                LinearGradient(colors: [Color.indigo.opacity(0.85), Color.cyan.opacity(0.85)],
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                            .stroke(Color.white.opacity(0.10), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)

                HourlyForecastSection(hours: forecast.forecastDays.first?.hours ?? [])
                    .padding(.horizontal, 0)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                            .fill(
                                LinearGradient(colors: [Color.teal.opacity(0.85), Color.blue.opacity(0.85)],
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                            .stroke(Color.white.opacity(0.10), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
            }
            .padding(.top, .spacing8)
        }
    }
}

private struct ForecastLandscapeLayout: View {
    let forecast: WeatherForecast

    var body: some View {
        ScrollView {
            HStack(alignment: .top, spacing: .spacing16) {
                VStack(spacing: .spacing16) {
                    CurrentForecastCard(current: forecast.current, location: forecast.location)
                        .padding(.horizontal, 0)
                        .background(
                            RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [Color.blue.opacity(0.85), Color.purple.opacity(0.85)],
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)

                    HourlyForecastSection(hours: forecast.forecastDays.first?.hours ?? [])
                        .padding(.horizontal, 0)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [Color.teal.opacity(0.85), Color.blue.opacity(0.85)],
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                                .stroke(Color.white.opacity(0.10), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: .spacing16) {
                    DaysForecastSection(days: forecast.forecastDays.prefix(Int.forecastDays).map { $0 })
                        .padding(.horizontal, 0)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [Color.indigo.opacity(0.85), Color.cyan.opacity(0.85)],
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: .cornerRadius16, style: .continuous)
                                .stroke(Color.white.opacity(0.10), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, .spacing8)
        }
    }
}

private extension CGFloat {
    static let spacing8: CGFloat = 8
    static let spacing12: CGFloat = 12
    static let spacing16: CGFloat = 16
    static let spacing20: CGFloat = 20
    static let spacing24: CGFloat = 24
    static let cornerRadius16: CGFloat = 16
    static let iconSize28: CGFloat = 28
    static let iconSize44: CGFloat = 44
    static let hourCellWidth: CGFloat = 74
    static let hourCellHeight: CGFloat = 92
}
