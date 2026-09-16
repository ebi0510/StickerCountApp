//
//  ContentView.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/09/05.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        Button("保存") {
            let newRecord = ConferenceRecord(name: "iOSDC", date: Date(), totalStickerCount: 42)
            context.insert(newRecord)
        }
    }
}


#Preview {
    ContentView()
}
