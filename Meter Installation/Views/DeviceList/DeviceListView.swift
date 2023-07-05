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
            Group {
                FilteredListView(
                    filter: viewModel.searchText,
                    state: viewModel.state,
                    selectedDevice: $viewModel.selectedDevice,
                    primaryAction: { device in
                        withAnimation {
                            viewModel.installDevice(device)
                        }
                    }
                )
            }
            .refreshable {
                await viewModel.updateDevices()
            }
            .toolbar {
                ToolbarContentView(state: viewModel.state) {
                    Task {
                        await viewModel.updateDevices()
                    }
                }
            }
            .task {
                await viewModel.updateDevicesIfNeeded()
            }
            .alert(
                viewModel.currentErrorTitle,
                isPresented: $viewModel.isShowingError,
                actions: {},
                message: { Text(viewModel.currentErrorMessage) }
            )
            .sheet(item: $viewModel.selectedDevice) { device in
                let viewModel = DeviceDetailsViewModel(device: device) {
                    self.viewModel.installDevice(device)
                }
                DeviceDetailsView(viewModel: viewModel)
            }
            .navigationTitle("Devices")
        }
        .searchable(text: $viewModel.searchText)
    }

}

struct DeviceListView_Previews: PreviewProvider {
    static let viewModel = DeviceListViewModel(dataStore: DataStorage.test)
    
    static var previews: some View {
        DeviceListView(viewModel: viewModel)
            .environment(\.managedObjectContext,
                          DataStorage.test.viewContext)
    }
}

private struct FilteredListView: View {
    @FetchRequest var devices: FetchedResults<Device>
    @Binding var selectedDevice: Device?
    let state: ViewState
    let primaryAction: (_ device: Device) -> Void

    init(filter: String, state: ViewState, selectedDevice: Binding<Device?>, primaryAction: @escaping (_ device: Device) -> Void) {
        _devices = FetchRequest<Device>(
            sortDescriptors: [SortDescriptor(\.id)],
            predicate: Self.makePredicate(filter: filter)
        )
        self.state = state
        self.primaryAction = primaryAction
        _selectedDevice = selectedDevice
    }

    var body: some View {
        Group {
            if devices.isEmpty {
                let (title, subtitle) = makeEmptyViewTexts(state: state)
                EmptyView(title: title, subtitle: subtitle)
            } else {
                List {
                    DeviceSectionView(
                        selectedDevice: $selectedDevice,
                        title: "Uninstalled Devices",
                        devices: uninstalledDevices,
                        primaryAction: primaryAction
                    )
                    DeviceSectionView(
                        selectedDevice: $selectedDevice,
                        title: "Installed Devices",
                        devices: installedDevices,
                        primaryAction: primaryAction
                    )
                }
                .listStyle(.sidebar)
            }
        }
    }

    private var installedDevices: [Device] { devices.filter{ $0.isInstalled }}

    private var uninstalledDevices: [Device] { devices.filter{ !$0.isInstalled }}

    private static func makePredicate(filter: String) -> NSPredicate {
        let syncedPredicate = PredicateMaker.makeSyncedPredicate(synced: true)

        guard !filter.isEmpty else { return syncedPredicate }

        let idPredicate = PredicateMaker.makeTextPredicate(propertyName: "id", value: filter)
        let meterPointPredicate = PredicateMaker.makeTextPredicate(propertyName: "meterPointDescription", value: filter)
        let filterPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [idPredicate, meterPointPredicate])
        return NSCompoundPredicate(andPredicateWithSubpredicates: [syncedPredicate, filterPredicate])
    }

    private func makeEmptyViewTexts(state: ViewState) -> (title: String, subtitle: String) {
        let title: String
        let subtitle: String
        switch state {
        case .success:
            title = "Have a beer! 🍻"
            subtitle = "There is no device to show."
        case .loading:
            title = "Loading devices... 👀"
            subtitle = "Please wait until your items are shown."
        case .failure:
            title = "Oups... 🙈"
            subtitle = "Something went wrong while loading your devices."
        }
        return (title, subtitle)
    }
}

private struct ToolbarContentView: View {
    let state: ViewState
    let refreshAction: () -> Void

    var body: some View {
        HStack {
            Button(title, action: refreshAction)
                .disabled(state == .loading)
        }
    }

    private var title: String { state == .loading ? "Refreshing..." : "Refresh" }
}
