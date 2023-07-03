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
        SortDescriptor(\.id)
    ]) var devices: FetchedResults<Device>
    
    var body: some View {
        List {
            ForEach(devices) { device in
                VStack(alignment: .leading) {
                    Text(device.identifier)
                    Text(device.meterPointText)
                }
            }
        }
        .refreshable {
            await viewModel.updateDevices()
        }
        .navigationTitle("Devices")
        .task {
            await viewModel.updateDevicesIfNeeded()
        }
    }
    
}

struct DeviceListView_Previews: PreviewProvider {
    static let viewModel = DeviceListViewModel(dataProvider: DataProvider.test)
    
    static var previews: some View {
        NavigationStack {
            DeviceListView(viewModel: viewModel)
                .environment(\.managedObjectContext,
                              DataProvider.test.container.viewContext)
        }
    }
}
