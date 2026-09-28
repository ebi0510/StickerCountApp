//
//  StickerCounter.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/09/29.
//
import Vision
import UIKit

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
    request.maximumImageDimension = 500
    
    
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
    
    // ⑥ サイズが妥当な輪郭だけにフィルタリングする
    // TODO: normalizedPath.boundingBoxの面積で絞り込む
    let validContours = contours.filter { contour in
        let area = contour.normalizedPath.boundingBox.width * contour.normalizedPath.boundingBox.height
        return area > 0.0005 && area < 0.02
    }
    return validContours.count   // TODO: 最終的にvalidContoursの数を返す
}
