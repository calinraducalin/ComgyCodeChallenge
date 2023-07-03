//
//  DeviceList.swift
//  Meter Installation
//
//  Created by Gernot Poetsch on 20.06.23.
//

import Foundation
import SwiftUI

struct DeviceListView: View {
    @StateObject var viewModel = DeviceListViewModel()
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.id),
    ], animation: .default) var devices: FetchedResults<Device>
    
    var body: some View {
        List {
            DeviceSectionView(title: "Uninstalled Devices", devices: uninstalledDevices)
            DeviceSectionView(title: "Installed Devices", devices: installedDevices)
        }
        .listStyle(.sidebar)
        .toolbar {
            ToolbarContentView(state: viewModel.state) {
                Task {
                    await viewModel.updateDevices()
                }
            }
        }
        .navigationTitle("Devices")
        .refreshable {
            await viewModel.updateDevices()
        }
        .task {
            await viewModel.updateDevicesIfNeeded()
        }
    }

    private var installedDevices: [Device] { devices.filter{ $0.isInstalled }}

    private var uninstalledDevices: [Device] { devices.filter{ !$0.isInstalled }}

}

struct DeviceListView_Previews: PreviewProvider {
    static let viewModel = DeviceListViewModel(dataProvider: DataProvider.preview)
    
    static var previews: some View {
        NavigationStack {
            DeviceListView(viewModel: viewModel)
                .environment(\.managedObjectContext,
                              DataProvider.preview.container.viewContext)
        }
    }
}

private struct DeviceSectionView: View {
    let title: String
    let devices: [Device]

    var body: some View {
        Group {
            if !devices.isEmpty {
                Section("\(title) (\(devices.count))") {
                    ForEach(devices, content: ListItemView.init)
                }
            }
        }
    }
}

private struct ListItemView: View {
    let device: Device

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: device.deviceType.systemImageName)
                .renderingMode(.template)
                .foregroundColor(device.deviceType.imageColor)
            VStack(alignment: .leading) {
                Text(device.identifier)
                Text(device.meterPointText)
            }
            Spacer()
            Image(systemName: device.status.systemImageName)
                .renderingMode(.template)
                .imageScale(.small)
                .foregroundColor(device.status.imageColor)

        }
    }
}

private struct ToolbarContentView: View {
    let state: ListViewState
    let refreshAction: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(title, action: refreshAction)
                .disabled(state == .syncing)
        }
    }

    private var title: String { state == .syncing ? "Refreshing..." : "Refresh" }
}

