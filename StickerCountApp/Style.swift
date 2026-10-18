//
//  Style.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/10/17.
//
import SwiftUI

struct TextStyleModifier: ViewModifier {
    let textStyle: TextStyle
    
    func body(content: Content) -> some View {
        content.font(textStyle.textFont)
    }
}

enum TextStyle{
    case titleText
    case subText
    case captionText
    
    
    var textFont: Font {
        switch self {
        case .titleText:
            return .title2
        case .subText:
            return .body
        case .captionText:
            return .caption
        }
    }
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.modifier(TextStyleModifier(textStyle: style))
    }
}

//extension View {
//    func ButtonStyle(){
//        self.modifier(MainButtonStyle)
//    }
//}

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

