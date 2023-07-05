//
//  MainView.swift
//  Meter Installation
//
//  Created by Gernot Poetsch on 20.06.23.
//

import Foundation
import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        TabView {
            DeviceListView(viewModel: .init(dataStore: viewModel.dataStore))
                .tabItem {
                    Label("Devices",
                          systemImage: "screwdriver")
                }
            SyncView(viewModel: .init(dataStore: viewModel.dataStore))
                .tabItem {
                    Label("Sync", systemImage: "arrow.2.circlepath")
                }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static let viewModel = MainViewModel(dataStore: DataStorage.test)

    static var previews: some View {
        MainView(viewModel: viewModel)
            .environment(\.managedObjectContext,
                          DataStorage.test.viewContext)
    }
}
