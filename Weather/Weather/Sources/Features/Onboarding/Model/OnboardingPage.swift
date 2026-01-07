//
//  OnboardingPage.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

struct OnboardingPage: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImageName: String
}
