//
//  StickerCounter.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/09/29.
//
import Vision
import UIKit
import SwiftUI

func countStickers(in image: UIImage) -> Int {
    guard let mask = makeMask(in: image) else {
        return 0
    }
    guard let cgImage = mask.cgImage else {
        return 0
    }
    
    // ① 「輪郭検出をしてください」という依頼書を作る
    // TODO: VNDetectContoursRequestのインスタンスを作る
    let request = VNDetectContoursRequest()
    request.detectsDarkOnLight = false
    
    // 依頼書に条件を書き込む
    // TODO: maximumImageDimensionを設定する(処理速度のための縮小サイズ)
    request.maximumImageDimension = 1000
    
    // ② 実行係を用意して、この写真を担当してもらう
    // TODO: VNImageRequestHandlerのインスタンスを作る(cgImageを渡す)
    let handler = VNImageRequestHandler(cgImage: cgImage)
    
    
    // ③ 実行する(エラーが起きる可能性があるのでtry/catchで)
    // TODO: handler.perform([...])を呼ぶ
    do {
        try handler.perform([request])
    } catch {
        print("エラーが発生しました: \(error)")
        return 0
    }
    
    // ④ 結果を取り出す(依頼書自身に結果が入っている)
    // TODO: request.results?.firstを安全に取り出す(guard let)
    guard let result = request.results?.first else {
        print("結果がありません")
        return 0
    }
    
    // ⑤ 一番外側の輪郭だけに絞る
    // TODO: topLevelContoursを取得する
    let topContours = result.topLevelContours
    let secondContours = topContours.flatMap { $0.childContours }
    let contours = topContours + secondContours
    let validData = contours.map{ validData in
        return validData.normalizedPath.boundingBox.width * validData.normalizedPath.boundingBox.height
    }
    let sortedData = validData.sorted()
    let underData = validData.filter{ underData in
        return underData < 0.0005
    }
    let overData = validData.filter{ overData in
        return overData > 0.005
    }
    let allContours = contours.map { contour in
        return contour.normalizedPath.boundingBox.width * contour.normalizedPath.boundingBox.height
    }
    let sortedAllContours = allContours.sorted().suffix(5)
    
    print("全体の面積：\(sortedData)")
    print("下限より小さい：\(underData.count)")
    print("上限より大きい：\(overData.count)")
    print("フィルタリング前：\(contours.count)")
    print("フィルタリング前の面積の配列：\(allContours)")
    print("フィルタリング前の大きい値（5個）：\(sortedAllContours)")
    
    // ⑥ サイズが妥当な輪郭だけにフィルタリングする
    // TODO: normalizedPath.boundingBoxの面積で絞り込む
    let validContours = contours.filter { contour in
        let area = contour.normalizedPath.boundingBox.width * contour.normalizedPath.boundingBox.height
        return area > 0.0005 && area < 0.005
    }
    print("フィルタリング後：\(validContours.count)")
    
    // ① validContoursから、面積だけを取り出した配列を作る
    let areas = validContours.map { contour in
        return contour.normalizedPath.boundingBox.width * contour.normalizedPath.boundingBox.height
    }

    // ② その配列を中央値を求めるためにソートする
    let sortedAreas = areas.sorted()
    print("フィルタリング後の面積の配列：\(sortedAreas)")
    
    // ③ 真ん中の値(中央値)を取り出す
    let middleIndex = sortedAreas.count / 2
    let middleItem = sortedAreas[middleIndex]
    print(sortedAreas)

    // ④ 合計面積を計算する
    let sumArea = sortedAreas.reduce(0, +)
    let sheets = Int(round(sumArea / middleItem))
    
    // 1段目: 一番外側の輪郭(今の contours)
    // 2段目: 1段目の、子どもたち
    let level2 = contours.flatMap { $0.childContours }

    // 3段目: 2段目の、子どもたち
    // TODO: level2 を使って、同じ形で書く
    let level3 = level2.flatMap { $0.childContours }

    // 4段目: 3段目の、子どもたち
    // TODO: 同じ形で書く
    let level4 = level3.flatMap { $0.childContours }

    print("1段目：\(contours.count)")
    print("2段目：\(level2.count)")
    print("3段目：\(level3.count)")
    print("4段目：\(level4.count)")
    
    print("すべての輪郭：\(result.contourCount)")
    print("一番外側の輪郭：\(result.topLevelContourCount)")

    // ⑤ 推定枚数 = 合計面積 ÷ 中央値(小数点は四捨五入)v
    return sheets   // validContours.count の代わりにこちらを返す
}
