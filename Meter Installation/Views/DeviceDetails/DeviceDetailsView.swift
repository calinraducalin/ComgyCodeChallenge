//
//  DeviceDetailsView.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import SwiftUI

struct DeviceDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isShowingConfirmation = false
    let device: Device
    let primaryAction: () -> Void

    var body: some View {
        NavigationStack {
            List {
                DeviceRowView(text: "Identifier", detailsText: device.identifier)
                DeviceRowView(text: "Type", detailsText: device.deviceType.description)
                DeviceRowView(text: "Meter Point", detailsText: device.meterPointText)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(ctaButtonTitle, role: ctaButtonRole, action: ctaButtonAction)
                    .buttonStyle(.borderedProminent)
                }
            }
            .confirmationDialog(confirmationTitle, isPresented: $isShowingConfirmation, titleVisibility: .visible) {
                Button("Uninstall", role: .destructive, action: confirmedCtaButtonAction)
                Button("Cancel", role: .cancel) { }
            }
            .navigationTitle(device.identifier)
        }
    }

    private var confirmationTitle: String {
        "Unsintall \(device.identifier)"
    }

    private var ctaButtonTitle: String { device.isInstalled ? "Uninstall" : "Install" }

    private var ctaButtonRole: ButtonRole? {
        device.isInstalled ? .destructive : .none
    }

    private func ctaButtonAction() {
        if device.isInstalled {
            isShowingConfirmation = true
        } else {
            confirmedCtaButtonAction()
        }
    }

    private func confirmedCtaButtonAction() {
        primaryAction()
        dismiss()
    }
}

struct DeviceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let device = Device(context: DataStorage.preview.viewContext)
        device.id = "WWM-0001-13"
        device.installationDate = Date()
        device.meterPointDescription = "Hallway"
        device.type = "cold_water"

        return DeviceDetailsView(device: device) { }
    }
}

private struct DeviceRowView: View {
    let text: String
    let detailsText: String

    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Text(detailsText)
                .foregroundColor(.secondary)
        }
    }

}
