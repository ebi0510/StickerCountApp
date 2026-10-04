//
//  ResultView.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/10/04.
//
import SwiftUI
import SwiftData

struct ResultView: View {
    @Environment(\.modelContext) private var context
    @State private var name: String = ""
    let count: Int
    var onRecorded: () -> Void

    var body: some View {
        VStack {
            Text("シールの数: \(count)枚")
            TextField("カンファレンス名を入力", text: $name)
            Button("保存"){
                let record = ConferenceRecord(name: name, date: Date(), totalStickerCount: count)
                context.insert(record)
                onRecorded()
            }
        }
    }
}
