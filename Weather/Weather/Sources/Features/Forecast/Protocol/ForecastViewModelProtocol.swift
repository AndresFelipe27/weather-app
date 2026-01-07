//
//  ForecastViewModelProtocol.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Combine
import Foundation

protocol ForecastViewModelProtocol: ObservableObject {
    var title: String { get }
    var state: ForecastViewModel.State { get }

    var isFavorite: Bool { get }
    var selectedLocation: Location { get }

    func onAppear()
    func onDisappear()
    func onTapBack()
    func onToggleFavorite()
}
