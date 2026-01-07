//
//  WeatherApp.swift
//  Weather
//
//  Created by Usuario on 3/01/26.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeContainerView(coordinator: NavigationCoordinator())
        }
    }
}
