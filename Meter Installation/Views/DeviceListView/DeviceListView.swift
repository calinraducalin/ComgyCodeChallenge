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
    
    var body: some View {
        NavigationStack {
            FilteredListView(filter: viewModel.searchText)
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
        .searchable(text: $viewModel.searchText)
    }

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

private struct FilteredListView: View {
    @FetchRequest var devices: FetchedResults<Device>

    init(filter: String) {
        _devices = FetchRequest<Device>(sortDescriptors: [SortDescriptor(\.id)], predicate: Self.makePredicate(filter: filter))
    }

    var body: some View {
        List {
            DeviceSectionView(title: "Uninstalled Devices", devices: uninstalledDevices)
            DeviceSectionView(title: "Installed Devices", devices: installedDevices)
        }
        .listStyle(.sidebar)
    }

    private var installedDevices: [Device] { devices.filter{ $0.isInstalled }}

    private var uninstalledDevices: [Device] { devices.filter{ !$0.isInstalled }}

    private static func makePredicate(filter: String) -> NSPredicate? {
        guard !filter.isEmpty else { return nil }

        func makeTextPredicate(propertyName: String, value: String) -> NSPredicate {
            NSPredicate(format: "%K BEGINSWITH[c] %@", propertyName, value)
        }
        let idPredicate = makeTextPredicate(propertyName: "id", value: filter)
        let meterPointPredicate = makeTextPredicate(propertyName: "meterPointDescription", value: filter)
        return NSCompoundPredicate(orPredicateWithSubpredicates: [idPredicate, meterPointPredicate])
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
