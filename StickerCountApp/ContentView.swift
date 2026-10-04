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
    @State private var capturedImage: UIImage? = nil
    @State private var flow: Flow = .history
    
    enum Flow{
        case history
        case camera
        case crop(UIImage)
        case result(Int)
    }
    
    var body: some View {
        
        NavigationStack {
            switch flow {
            case .history:
                HistoryView(onAdded: {
                    flow = .camera
                })
            case .camera:
                CameraView(image: $capturedImage)
            case .crop(let image):
                CropView(image: image,
                         onCropped: { croppedImage in
                    flow = .result(countStickers(in: croppedImage))
                })
            case .result(let count):
                ResultView(count: count,
                           onRecorded: {
                    flow = .history
                })
            }
        }
        .onChange(of: capturedImage) { oldValue, newValue in
            if let newValue = newValue {
                flow = .crop(newValue)
            }
        }
    }
    
}

#Preview {
    ContentView()
}
