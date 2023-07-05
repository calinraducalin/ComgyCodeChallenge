//
//  ViewStateErrorHandler.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import Foundation

@MainActor
protocol ViewStateErrorHandler: AnyObject {
    var state: ViewState { get }
    var currentErrorTitle: String { get }
    var currentErrorMessage: String { get }
}

extension ViewStateErrorHandler {
    var currentErrorTitle: String { "Ooups! 🙈" }

    var currentErrorMessage: String {
        let currentError: MeterInstallationError
        if case let .failure(error) = state {
            currentError = error
        } else {
            currentError = .unknown
        }
        return currentError.localizedDescription
    }
}
