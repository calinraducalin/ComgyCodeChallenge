//
//  DeviceDetailsViewModel.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import SwiftUI

@MainActor
final class DeviceDetailsViewModel: ObservableObject {
    @Published var isShowingConfirmation = false
    @Published var shouldDismiss = false
    let device: Device
    let primaryAction: () -> Void

    init(device: Device, primaryAction: @escaping () -> Void) {
        self.device = device
        self.primaryAction = primaryAction
    }

    var shouldShowCtaButton: Bool {
        !(device.synced && device.isInstalled)
    }

    var confirmationTitle: String {
        "Unsintall \(device.identifier)"
    }

    var ctaButtonTitle: String { device.isInstalled ? "Uninstall" : "Install" }

    var ctaButtonRole: ButtonRole? {
        device.isInstalled ? .destructive : .none
    }

    func ctaButtonAction() {
        if device.isInstalled {
            isShowingConfirmation = true
        } else {
            confirmedCtaButtonAction()
        }
    }

    func confirmedCtaButtonAction() {
        primaryAction()
        shouldDismiss = true
    }
}
