//
//  StickerCounter.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/09/29.
//
import Vision
import UIKit
import SwiftUI

struct CountButton: View{
    @State private var statusMessage: String = "「テスト実行」を押してください"
    var body: some View {
        Text(statusMessage)
        Button("テスト実行"){
            guard let testImage = UIImage(named: "testPanel") else {
                statusMessage = "【エラー】 Assetsに「testPanel」画像が見つかりません"
                return
            }
           let count = countStickers(in: testImage)
            statusMessage = "【成功】 検出されたステッカー数: \(count)個"
        }
    }
}

func countStickers(in image: UIImage) -> Int {
    guard let cgImage = image.cgImage else { return 0 }
    
    // ① 「輪郭検出をしてください」という依頼書を作る
    // TODO: VNDetectContoursRequestのインスタンスを作る
    let request = VNDetectContoursRequest()
    
    // 依頼書に条件を書き込む
    // TODO: contrastAdjustmentを設定する(境界をくっきりさせる)
    // TODO: detectsDarkOnLightを設定する(明るい背景+暗い対象物の前提)
    // TODO: maximumImageDimensionを設定する(処理速度のための縮小サイズ)
    request.contrastAdjustment = 1.5
    request.detectsDarkOnLight = true
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
    let contours = result.topLevelContours
    print(contours)
    
    // ⑥ サイズが妥当な輪郭だけにフィルタリングする
    // TODO: normalizedPath.boundingBoxの面積で絞り込む
    let validContours = contours.filter { contour in
        let area = contour.normalizedPath.boundingBox.width * contour.normalizedPath.boundingBox.height
        return area > 0.0005 && area < 0.005
    }
    
    // ① validContoursから、面積だけを取り出した配列を作る
    let areas = validContours.map { contour in
        return contour.normalizedPath.boundingBox.width * contour.normalizedPath.boundingBox.height
    }

    // ② その配列を中央値を求めるためにソートする
    let sortedAreas = areas.sorted()
    
    // ③ 真ん中の値(中央値)を取り出す
    let middleIndex = sortedAreas.count / 2
    let middleItem = sortedAreas[middleIndex]
    print(sortedAreas)

    // ④ 合計面積を計算する
    let sumArea = sortedAreas.reduce(0, +)
    let sheets = Int(round(sumArea / middleItem))

    // ⑤ 推定枚数 = 合計面積 ÷ 中央値(小数点は四捨五入)v
    return sheets   // validContours.count の代わりにこちらを返す
}

#Preview {
    CountButton()
}
