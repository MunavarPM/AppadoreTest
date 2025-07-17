//
//  AppadoreApp.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import SwiftUI

@main
struct AppadoreApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var appViewModel = AppManager()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ScheduleView()
                    .environmentObject(appViewModel)
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background || newPhase == .inactive {
                    appViewModel.saveGameState()
                }
            }
        }
    }
}
