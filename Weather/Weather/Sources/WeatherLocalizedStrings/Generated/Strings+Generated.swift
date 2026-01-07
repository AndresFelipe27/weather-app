// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Check the forecast for the next days in seconds
  public static let checkTheForecastForTheNextDaysInSeconds = L10n.tr("Localizable", "checkTheForecastForTheNextDaysInSeconds", fallback: "Check the forecast for the next days in seconds")
  /// Continue
  public static let `continue` = L10n.tr("Localizable", "continue", fallback: "Continue")
  /// Discover the weather in your city and plan your day correctly
  public static let discoverTheWeatherInYourCityAndPlanYourDayCorrectly = L10n.tr("Localizable", "discoverTheWeatherInYourCityAndPlanYourDayCorrectly", fallback: "Discover the weather in your city and plan your day correctly")
  /// Favorites
  public static let favorites = L10n.tr("Localizable", "favorites", fallback: "Favorites")
  /// Favorites
  public static let favoritesTitle = L10n.tr("Localizable", "favoritesTitle", fallback: "Favorites")
  /// Feels like
  public static let feelsLike = L10n.tr("Localizable", "feelsLike", fallback: "Feels like")
  /// Forecast
  public static let forecast = L10n.tr("Localizable", "forecast", fallback: "Forecast")
  /// Humidity
  public static let humidity = L10n.tr("Localizable", "humidity", fallback: "Humidity")
  /// Mark locations as favorites from the forecast screen.
  public static let markLocationsAsFavoritesFromTheForecastScreen = L10n.tr("Localizable", "markLocationsAsFavoritesFromTheForecastScreen", fallback: "Mark locations as favorites from the forecast screen.")
  /// Next 24 hours
  public static let next24Hours = L10n.tr("Localizable", "next24Hours", fallback: "Next 24 hours")
  /// Next 3 days
  public static let next3Days = L10n.tr("Localizable", "next3Days", fallback: "Next 3 days")
  /// No favorites yet
  public static let noFavoritesYet = L10n.tr("Localizable", "noFavoritesYet", fallback: "No favorites yet")
  /// No results
  public static let noResults = L10n.tr("Localizable", "noResults", fallback: "No results")
  /// Please try again.
  public static let pleaseTryAgain = L10n.tr("Localizable", "pleaseTryAgain", fallback: "Please try again.")
  /// Search a location
  public static let searchALocation = L10n.tr("Localizable", "searchALocation", fallback: "Search a location")
  /// Search for a city...
  public static let searchForACity = L10n.tr("Localizable", "searchForACity", fallback: "Search for a city...")
  /// Something went wrong
  public static let somethingWentWrong = L10n.tr("Localizable", "somethingWentWrong", fallback: "Something went wrong")
  /// Try another city name.
  public static let tryAnotherCityName = L10n.tr("Localizable", "tryAnotherCityName", fallback: "Try another city name.")
  /// Type a city name to see suggestions instantly.
  public static let typeACityNameToSeeSuggestionsInstantly = L10n.tr("Localizable", "typeACityNameToSeeSuggestionsInstantly", fallback: "Type a city name to see suggestions instantly.")
  /// Unknown error
  public static let unknownError = L10n.tr("Localizable", "unknownError", fallback: "Unknown error")
  /// UV
  public static let uv = L10n.tr("Localizable", "uv", fallback: "UV")
  /// Weather
  public static let weather = L10n.tr("Localizable", "weather", fallback: "Weather")
  /// Weather App
  public static let weatherApp = L10n.tr("Localizable", "weatherApp", fallback: "Weather App")
  /// Wind
  public static let wind = L10n.tr("Localizable", "wind", fallback: "Wind")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
