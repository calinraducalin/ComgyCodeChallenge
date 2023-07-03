//
//  SyncView.swift
//  Meter Installation
//
//  Created by Gernot Poetsch on 20.06.23.
//

import Foundation
import SwiftUI

struct SyncView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Task")
                .font(.title)
            Text("Display all devices that are marked to sync with the server and add a button that triggers the sync.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Sync")
    }
    
}

struct SyncView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SyncView()
        }
    }
}
