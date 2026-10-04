//
//  ConferenceCode.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/09/17.
//

import SwiftData
import Foundation

@Model
class ConferenceRecord {
    var name: String
    var date: Date
    var totalStickerCount: Int

    init(name: String, date: Date, totalStickerCount: Int) {
        self.name = name
        self.date = date
        self.totalStickerCount = totalStickerCount
    }
}
