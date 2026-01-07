//
//  OnboardingViewModelProtocol.swift
//  Weather
//
//  Created by Usuario on 3/01/26.
//

import Combine

protocol OnboardingViewModelProtocol: AnyObject, ObservableObject {
    var pages: [OnboardingPage] { get }
    var selectedIndex: Int { get set }

    func onTapContinue()
}
