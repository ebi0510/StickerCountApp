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
    @State private var showCamera: Bool = false
    @State private var capturedImage: UIImage?

    var body: some View {
        VStack {
            Button("保存") {
                let newRecord = ConferenceRecord(name: "iOSDC", date: Date(), totalStickerCount: 42)
                context.insert(newRecord)
            }
            Button("カメラを開く"){
                showCamera = true
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(image: $capturedImage)
        }
    }
}


#Preview {
    ContentView()
}
