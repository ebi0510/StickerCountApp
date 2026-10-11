//
//  MakeMask.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/10/07.
//
import SwiftUI

func makeMask(in image: UIImage) -> UIImage?{
    guard let cgImage = image.cgImage else { return nil}
    
    let imageWidth = cgImage.width
    let imageHeight = cgImage.height
    var imagePixels = [UInt8](repeating: 0, count:imageWidth*imageHeight*4)
    guard let cgContext = CGContext(
        data: &imagePixels,
        width: imageWidth,
        height: imageHeight,
        bitsPerComponent: 8,
        bytesPerRow: imageWidth * 4,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else { return nil}
    
    cgContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
    
    // 色なし（白）を黒に、色ありを白に変換したデータを作成する
    var maskPixels = [UInt8](repeating: 255, count: imageWidth * imageHeight * 4)
    for y in 0 ..< imageHeight {
        for x in 0 ..< imageWidth {
            let index = (y * imageWidth + x) * 4
            let r = imagePixels[index]
            let g = imagePixels[index + 1]
            let b = imagePixels[index + 2]
            
            let rgbDifference = max(r, g, b) - min(r, g, b)
            
            //閾値が60以上は色ありと判定する
            if rgbDifference < 60{
                maskPixels[index] = 0
                maskPixels[index+1]=0
                maskPixels[index+2]=0
                maskPixels[index+3]=255
            } else {
                maskPixels[index] = 255
                maskPixels[index+1]=255
                maskPixels[index+2]=255
                maskPixels[index+3]=255
            }
        }
    }
    guard let maskContext = CGContext(
        data: &maskPixels,
        width: imageWidth,
        height: imageHeight,
        bitsPerComponent: 8,
        bytesPerRow: imageWidth * 4,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else {
        return nil
    }
    
    guard let maskCGImage = maskContext.makeImage()
    else {
        return nil
    }
    
    return UIImage(cgImage: maskCGImage)
}
