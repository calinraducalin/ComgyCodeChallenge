//
//  Logger.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import OSLog

class AppLogger {
    static let data = Logger(subsystem: subsystem, category: "Data")

    private static let subsystem: String = Bundle.main.bundleIdentifier ?? ""
}
