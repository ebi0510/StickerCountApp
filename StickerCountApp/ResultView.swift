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
    @State private var chooseDate: Date = Date()
    let count: Int
    var onRecorded: () -> Void
    var onRecropped: () -> Void
    var onReturn: () -> Void
    
    var body: some View {
        VStack(alignment: .center) {
            Text("シールの数: \(count)枚")
                .textStyle(.titleText)
            TextField("カンファレンス名を入力", text: $name)
                .multilineTextAlignment(.center)
                .padding(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
            DatePicker(
                "日付を選択",
                selection: $chooseDate,
                in: ...Date(),
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
            .environment(\.locale, Locale(identifier: "ja_JP"))
            Button("保存"){
                let record = ConferenceRecord(
                    name: name,
                    date: chooseDate,
                    totalStickerCount: count
                )
                context.insert(record)
                onRecorded()
            }
            .disabled(name.isEmpty)
            .modifier(MainButtonStyle())
            
            HStack(spacing: 20) {
                Button("再トリミング"){
                    onRecropped()
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
                Button("トップに戻る"){
                    onReturn()
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.primary)
                .controlSize(.regular)
            }
        }
        .padding(30)
        
        
        
    }
}
