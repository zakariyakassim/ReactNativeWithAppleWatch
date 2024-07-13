//
//  healthAppWatchApp.swift
//  healthAppWatch Watch App
//
//  Created by Zak Mohamed on 11/07/2024.
//

import SwiftUI
@main
struct healthAppWatch_Watch_AppApp: App {
  @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate: ExtensionDelegate

    var body: some Scene {
        WindowGroup {
         
            ContentView2()
        }
    }
}
