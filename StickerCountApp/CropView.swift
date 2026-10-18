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
    
    var onCropped: (UIImage) -> Void
    // 枠の現在位置（後でcropOffsetを.zeroに戻す。TS 205枚。iOS 86）
    @State private var cropOffset: CGSize = CGSize(width: -1, height: 30.33)
    @State private var lastOffset: CGSize = CGSize(width: 200, height: 200)
    
    // 枠の大きさ（cropSizeを後でCGSize(width: 200, height: 200)に戻す）
    @State private var cropSize: CGSize = CGSize(width: 348, height: 179)
    @State private var lastSize: CGSize = CGSize(width: 200, height: 200)
    
    // 画像の基準位置・サイズ、枠のoffsetする前の基準位置
    @State private var imageFrame: CGRect = .zero
    @State private var rectBaseFrame: CGRect = .zero
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
                Text("黄色い枠でシールが貼ってある範囲を囲ってください")
                    .multilineTextAlignment(.center)
                    .textStyle(.titleText)
                Text("その際以下に注意してください")
                    .textStyle(.subText)
                    .multilineTextAlignment(.center)
                Text("回答枠まで含めること\n回答枠の線と黄色い枠が重ならないこと\nシール以外のものが入りすぎないようにすること")
                    .textStyle(.captionText)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal,25)
            
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    imageFrame = geo.frame(in: .named("cropSpace"))
                                }
                                .onChange(of: geo.size) { oldValue, newValue in
                                    imageFrame = geo.frame(in: .named("cropSpace"))
                                }
                        }
                    )
                
                
                ZStack (alignment: .bottomTrailing){
                    Rectangle()
                        .stroke(Color.yellow, lineWidth: 3)
                        .frame(width: cropSize.width, height: cropSize.height)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    cropOffset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                                .onEnded { value in
                                    lastOffset = cropOffset
                                    print("位置：\(cropOffset)")
                                }
                        )
                    
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 20, height: 20)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    cropSize = CGSize(
                                        width: lastSize.width + value.translation.width,
                                        height: lastSize.height + value.translation.height)
                                }
                                .onEnded { value in
                                    lastSize = cropSize
                                    print("サイズ：\(cropSize)")
                                }
                        )
                }
                
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                rectBaseFrame = geo.frame(in: .named("cropSpace"))
                            }
                            .onChange(of: cropSize) { oldValue, newValue in
                                rectBaseFrame = geo.frame(in: .named("cropSpace"))
                            }
                    }
                )
                .offset(cropOffset)
            }
            .coordinateSpace(name: "cropSpace")
            .padding(.horizontal, 15)
            
            Button("確定") {
                if let cropped = cropImage() {
                    onCropped(cropped)
                }
            }
            .modifier(MainButtonStyle())
        }
    }
    
    
    func cropImage() -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        // 横・縦それぞれのスケール（元画像ピクセル ÷ 表示サイズ）
        let scaleX = CGFloat(cgImage.width) / imageFrame.width
        let scaleY = CGFloat(cgImage.height) / imageFrame.height
        
        // 枠の現在位置（基準位置 + ドラッグで動いた量）
        let nowPositionX = rectBaseFrame.origin.x + cropOffset.width
        let nowPositionY = rectBaseFrame.origin.y + cropOffset.height
        
        // 画像の左上からの相対位置
        let relativeX = nowPositionX - imageFrame.origin.x
        let relativeY = nowPositionY - imageFrame.origin.y
        
        // ピクセル単位に変換
        let x = relativeX * scaleX
        let y = relativeY * scaleY
        let width = cropSize.width * scaleX
        let height = cropSize.height * scaleY
        
        let pixelRect = CGRect(x: x, y: y, width: width, height: height)
        
        guard let croppedCGImage = cgImage.cropping(to: pixelRect) else {
            print("切り抜きに失敗しました")
            return nil
        }
        
        return UIImage(cgImage: croppedCGImage)
    }
}
