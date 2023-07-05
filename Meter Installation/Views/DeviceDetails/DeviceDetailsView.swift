//
//  DeviceDetailsView.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import SwiftUI

struct DeviceDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: DeviceDetailsViewModel

    init(viewModel: DeviceDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                DeviceRowView(text: "Identifier", detailsText: viewModel.device.identifier)
                DeviceRowView(text: "Type", detailsText: viewModel.device.deviceType.description)
                DeviceRowView(text: "Meter Point", detailsText: viewModel.device.meterPointText)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                if viewModel.shouldShowCtaButton {
                    ToolbarItem(placement: .bottomBar) {
                        Button(viewModel.ctaButtonTitle, role: viewModel.ctaButtonRole) {
                            viewModel.ctaButtonAction()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .confirmationDialog(viewModel.confirmationTitle, isPresented: $viewModel.isShowingConfirmation, titleVisibility: .visible) {
                Button("Uninstall", role: .destructive) {
                    viewModel.confirmedCtaButtonAction()
                }
                Button("Cancel", role: .cancel) {}
            }
            .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
            .navigationTitle(viewModel.device.identifier)
        }
    }
}

struct DeviceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let device = Device(context: DataStorage.preview.viewContext)
        device.id = "WWM-0001-13"
        device.installationDate = Date()
        device.meterPointDescription = "Hallway"
        device.type = "cold_water"

        let viewModel = DeviceDetailsViewModel(device: device) {}
        return DeviceDetailsView(viewModel: viewModel)
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
