//
//  MeterInstallationApp.swift
//  Meter Installation
//
//  Created by Gernot Poetsch on 19.06.23.
//

import Foundation
import SwiftUI

@main
struct MeterInstallationApp: App {
    
    var body: some Scene {
        WindowGroup {
            if isRunningUnitTests {
                ProgressView {
                    Text("🤞 Running unit tests...")
                }
            } else {
                MainView()
                    .environment(\.managedObjectContext, DataStorage.shared.viewContext)
            }
        }
    }

    private var isRunningUnitTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}

