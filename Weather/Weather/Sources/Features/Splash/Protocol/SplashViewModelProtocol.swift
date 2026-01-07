//
//  SplashViewModelProtocol.swift
//  Weather
//
//  Created by Usuario on 3/01/26.
//

import Combine

protocol SplashViewModelProtocol: AnyObject, ObservableObject {
    var isAnimating: Bool { get }

    func onAppear()
}
