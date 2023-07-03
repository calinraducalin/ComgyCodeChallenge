//
//  MainView.swift
//  Meter Installation
//
//  Created by Gernot Poetsch on 20.06.23.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            NavigationStack {
                DeviceOverview()
            }
            .tabItem {
                Label("Devices",
                      systemImage: "screwdriver")
            }
            NavigationStack {
                SyncView()
            }
            .tabItem {
                Label("Sync", systemImage: "arrow.2.circlepath")
            }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
