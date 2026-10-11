//
//  HistoryView.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/10/04.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \ConferenceRecord.date, order: .reverse) private var records: [ConferenceRecord]
    @Environment(\.modelContext) private var context
    var onAdded: () -> Void
    
    var body: some View {
        List { ForEach(records) { record in
            HStack {
                Text(record.date.formatted(
                    .dateTime
                    .year()
                    .month(.twoDigits)
                    .day(.twoDigits)
                    .locale(Locale(identifier: "ja_JP"))
                ))

                Text(record.name)
                Text("\(record.totalStickerCount)枚")
            }
        }
        .onDelete { indexSet in
            for index in indexSet {
                context.delete(records[index])
            }
        }
        }
        .toolbar {
            ToolbarItem(placement:.topBarTrailing){
                Button("追加" , systemImage: "plus"){
                    onAdded()
                }
            }
        }
    }
}


