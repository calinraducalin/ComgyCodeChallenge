//
//  SyncView.swift
//  Meter Installation
//
//  Created by Gernot Poetsch on 20.06.23.
//

import Foundation
import SwiftUI

struct SyncView: View {
    @StateObject var viewModel = SyncViewModel()
    @State private var selectedDevice: Device?
    @FetchRequest(
        sortDescriptors: [ SortDescriptor(\.id)],
        predicate: PredicateMaker.makeSyncedPredicate(synced: false),
        animation: .default
    ) var devices: FetchedResults<Device>
    
    var body: some View {
        NavigationStack {
            Group {
                if devices.isEmpty {
                    EmptyView(title: "All good! 🙌", subtitle: "All the devices are synced.")
                } else {
                    List {
                        DeviceSectionView(
                            selectedDevice: $selectedDevice,
                            title: "Unsynced Devices",
                            devices: devices.map { $0 },
                            primaryAction: deleteAction
                        )
                    }
                }
            }
            .toolbar {
                ToolbarContentView(state: viewModel.state, devices: deviceList) {
                    Task {
                        await viewModel.syncDevices(deviceList)
                    }
                }
            }
            .sheet(item: $selectedDevice) { device in
                let viewModel = DeviceDetailsViewModel(device: device) {
                    deleteAction(device: device)
                }

                DeviceDetailsView(viewModel: viewModel)
            }
            .alert(
                viewModel.currentErrorTitle,
                isPresented: $viewModel.isShowingError,
                actions: {},
                message: { Text(viewModel.currentErrorMessage) }
            )
            .navigationTitle("Sync")
        }
        .badge(devices.count)
    }

    private var deviceList: [Device] { devices.map { $0} }

    private func deleteAction(device: Device) {
        withAnimation {
            viewModel.uninstallDevice(device)
        }
    }

}

struct SyncView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SyncViewModel(dataStore: DataStorage.test)

        let device0 = Device(context: DataStorage.test.viewContext)
        device0.id = "WWM-0001-12"
        device0.installationDate = Date()
        device0.meterPointDescription = "Kitchen"
        device0.type = "warm_water"
        device0.synced = false

        let device1 = Device(context: DataStorage.test.viewContext)
        device1.id = "WWM-0001-13"
        device1.installationDate = Date()
        device1.meterPointDescription = "Hallway"
        device1.type = "cold_water"
        device1.synced = false

        DataStorage.test.viewContext.saveIfNeeded()

        return NavigationStack {
            SyncView(viewModel: viewModel)
                .environment(\.managedObjectContext,
                              DataStorage.test.viewContext)
        }

    }
}

private struct ToolbarContentView: View {
    let state: ViewState
    let devices: [Device]
    let syncAction: () -> Void

    var body: some View {
        Group {
            if !devices.isEmpty {
                Button(action: syncAction) {
                    if state == .loading {
                        HStack(spacing: 8) {
                            Text("Syncing...")
                            ProgressView()
                        }
                    } else {
                        Text("Sync")
                    }
                }
                .disabled(state == .loading)
            }
        }
    }
}
