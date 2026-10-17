//
//  Style.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/10/17.
//
import SwiftUI

extension Color{
    static let backgroundColor = Color("LightBlue")
}

struct MainButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .buttonBorderShape(.capsule)
            .controlSize(.regular)
            .padding(10)
        
    }
}

