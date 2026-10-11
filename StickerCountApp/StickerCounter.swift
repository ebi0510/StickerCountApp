//
//  StickerCounter.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/09/29.
//
import Vision
import UIKit

func countStickers(in image: UIImage) -> Int {
    // 0.0005より大きく0.005より小さい
    let maxArea = 0.005
    let minArea = 0.0005
    
    guard let mask = makeMask(in: image) else {
        return 0
    }
    guard let cgImage = mask.cgImage else {
        return 0
    }
    
    // 「輪郭検出をしてください」という依頼書を作る
    let request = VNDetectContoursRequest()
    request.detectsDarkOnLight = false
    
    // 依頼書に条件を書き込む
    request.maximumImageDimension = 1000
    
    // 実行係を用意して、この写真を担当してもらう
    let handler = VNImageRequestHandler(cgImage: cgImage)
    
    // 実行する(エラーが起きる可能性があるのでtry/catchで)
    do {
        try handler.perform([request])
    } catch {
        print("エラーが発生しました: \(error)")
        return 0
    }
    
    // 結果を取り出す(依頼書自身に結果が入っている)
    guard let result = request.results?.first else {
        print("結果がありません")
        return 0
    }
    
    // 一番外側の輪郭+二番目の輪郭に絞る
    let topContours = result.topLevelContours
    let secondContours = topContours.flatMap { $0.childContours }
    let allContours = topContours + secondContours
    
    // サイズが妥当な輪郭だけにフィルタリングする
    let validContours = allContours.filter { contour in
        let area = contour.normalizedPath.boundingBox.width * contour.normalizedPath.boundingBox.height
        return area > minArea && area < maxArea
    }
    
    // validContoursから、面積だけを取り出した配列を作る
    let areas = validContours.map { contour in
        return contour.normalizedPath.boundingBox.width * contour.normalizedPath.boundingBox.height
    }
    
    // その配列を中央値を求めるためにソートする
    let sortedAreas = areas.sorted()
    
    // 真ん中の値(中央値)を取り出す
    if sortedAreas.isEmpty {
        return 0
    }
    let middleIndex = sortedAreas.count / 2
    let middleItem = sortedAreas[middleIndex]
    
    // 合計面積を計算する
    let sumArea = sortedAreas.reduce(0, +)
    let sheets = Int(round(sumArea / middleItem))
    
    return sheets
}
