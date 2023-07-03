//
//  DeviceList.swift
//  Meter Installation
//
//  Created by Gernot Poetsch on 20.06.23.
//

import Foundation
import SwiftUI

struct DeviceOverview: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Task")
                .font(.title)
            Text("Display a list of all devices from the server and provide a way to mark a device for installation by setting an installation time. Do not sync to the API yet.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Devices")
    }
    
}

struct DeviceOverview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DeviceOverview()
        }
    }
}
