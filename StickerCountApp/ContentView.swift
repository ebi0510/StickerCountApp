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
//    あとで.historyに直す
    @State private var flow: Flow = .crop(UIImage(named: "testPanel3")!)
    
    enum Flow{
//        case history
//        case camera
        case crop(UIImage)
        case result(Int)
    }
    
    var body: some View {
        
        NavigationStack {
            switch flow {
//            case .history:
//                HistoryView(onAdded: {
//                    flow = .camera
//                })
//            case .camera:
//                CameraView(image: $capturedImage)
            case .crop(let image):
                CropView(image: image,
                         onCropped: { croppedImage in
                    flow = .result(countStickers(in: croppedImage))
                })
            case .result(let count):
                ResultView(count: count,
                           onRecorded: {
//                    あとで.historyに戻す
                    flow = .crop(UIImage(named: "testPanel3")!)
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
