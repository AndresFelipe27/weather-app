//
//  HourTimeFormatter.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

final class HourTimeFormatter {
    static let shared = HourTimeFormatter()

    private let inputFormatter: DateFormatter
    private let outputFormatter: DateFormatter

    private init() {
        let input = DateFormatter()
        input.locale = Locale(identifier: "en_US_POSIX")
        input.dateFormat = "yyyy-MM-dd HH:mm"

        let output = DateFormatter()
        output.locale = Locale.current
        output.dateFormat = "ha"

        self.inputFormatter = input
        self.outputFormatter = output
    }

    func format(_ timeString: String) -> String {
        guard let date = inputFormatter.date(from: timeString) else {
            return timeString.split(separator: " ").last.map(String.init) ?? timeString
        }
        return outputFormatter.string(from: date)
    }
}
