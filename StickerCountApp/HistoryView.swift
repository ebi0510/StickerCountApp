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
        Group {
            if records.isEmpty {
                ContentUnavailableView("データがありません",
                                       systemImage: "magnifyingglass",
                                       description: Text("追加するには＋ボタンをタップ")
                )
            } else {
                List { ForEach(records) { record in
                    HStack {
                        Text(record.date.formatted(
                            .dateTime
                                .year()
                                .month(.twoDigits)
                                .day(.twoDigits)
                                .locale(Locale(identifier: "ja_JP"))
                        ))
                        .minimumScaleFactor(0.5)
                        .monospacedDigit()
                        .lineLimit(1)
                        .layoutPriority(3)
                        Text(record.name)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .layoutPriority(1)
                        Text("\(record.totalStickerCount)枚")
                            .minimumScaleFactor(0.5)
                            .frame(width: 55, alignment: .leading)
                            .lineLimit(1)
                            .layoutPriority(2)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(records[index])
                    }
                }
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


