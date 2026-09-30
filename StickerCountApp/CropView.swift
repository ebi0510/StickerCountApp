//
//  CropView.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/10/01.
//
import SwiftUI

struct CropView: View {
    // CameraViewから受け取った、トリミング前の画像
    let image: UIImage
    // 枠の現在位置
    @State private var cropOffset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        VStack {
            Text("パネルがまっすぐ、画面いっぱいに写るようにトリミングしてください")
            
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Rectangle()
                    .stroke(Color.yellow, lineWidth: 3)
                    .frame(width: 200, height: 200)
                    .contentShape(Rectangle())
                    .offset(cropOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // TODO: ここで cropOffset を value.translation に更新する
                                cropOffset = CGSize(
                                                width: lastOffset.width + value.translation.width,
                                                height: lastOffset.height + value.translation.height
                                            )
                            }
                            .onEnded { value in
                                lastOffset = cropOffset
                            }
                    )
            }
        }
    }
}

#Preview {
    CropView(image: UIImage(named: "testPanel")!)
}
