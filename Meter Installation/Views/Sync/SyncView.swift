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
                            title: "Unsynced Devices",
                            devices: devices.map { $0 },
                            primaryAction: deleteAction
                        )
                    }
                }
            }
            .toolbar {
                ToolbarContentView(state: viewModel.state, devices: deviceList) {

                }
            }
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
        let viewModel = SyncViewModel(dataProvider: DataProvider.preview)

        let device0 = Device(context: DataProvider.preview.viewContext)
        device0.id = "WWM-0001-12"
        device0.installationDate = Date()
        device0.meterPointDescription = "Kitchen"
        device0.type = "warm_water"
        device0.synced = false

        let device1 = Device(context: DataProvider.preview.viewContext)
        device1.id = "WWM-0001-13"
        device1.installationDate = Date()
        device1.meterPointDescription = "Hallway"
        device1.type = "cold_water"
        device1.synced = false

        DataProvider.preview.viewContext.saveIfNeeded()

        return NavigationStack {
            SyncView(viewModel: viewModel)
                .environment(\.managedObjectContext,
                              DataProvider.preview.viewContext)
        }

    }
}

private struct ToolbarContentView: View {
    let state: ListViewState
    let devices: [Device]
    let syncAction: () -> Void

    var body: some View {
        HStack {
            if !devices.isEmpty {
                Button(title, action: syncAction)
                    .disabled(state == .loading)
            }
        }
    }

    private var title: String { state == .loading ? "Syncing..." : "Sync" }
}
