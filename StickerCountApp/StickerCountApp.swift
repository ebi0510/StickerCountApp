//
//  StickerCountApp.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/09/05.
//

import SwiftUI
import SwiftData

@main
struct StickerCountApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ConferenceRecord.self)
    }
}
