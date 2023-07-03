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
            DeviceListView(viewModel: .init(dataProvider: viewModel.dataProvider))
                .tabItem {
                    Label("Devices",
                          systemImage: "screwdriver")
                }
            SyncView()
                .tabItem {
                    Label("Sync", systemImage: "arrow.2.circlepath")
                }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static let viewModel = MainViewModel(dataProvider: DataProvider.preview)

    static var previews: some View {
        MainView(viewModel: viewModel)
            .environment(\.managedObjectContext,
                          DataProvider.preview.container.viewContext)
    }
}
