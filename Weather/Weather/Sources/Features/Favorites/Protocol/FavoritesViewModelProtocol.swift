//
//  FavoritesViewModelProtocol.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

protocol FavoritesViewModelProtocol: AnyObject, ObservableObject {
    var favorites: [Location] { get }

    func onAppear()
    func onTapLocation(_ location: Location)
}
