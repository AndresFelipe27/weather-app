//
//  SearchViewModelProtocol.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Combine
import Foundation

protocol SearchViewModelProtocol: AnyObject, ObservableObject {
    var query: String { get set }
    var locations: [Location] { get }
    var viewState: SearchViewState { get }
    var errorMessage: String? { get }

    func onAppear()
    func onTapFavorites()
    func onTapLocation(_ location: Location)
}
