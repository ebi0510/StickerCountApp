//
//  CameraView.swift
//  StickerCountApp
//
//  Created by 岡野春菜 on 2026/09/27.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
//  ?はOptionalで不確定要素。存在したらアクセスするイメージ
    @Binding var image: UIImage?
//　SwiftUIでUIKitのビューコントローラー（UIViewController）を利用するためのプロトコル。最初の一回しか使わないらしい
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
//  カメラモードに設定
        picker.sourceType = .camera
        return picker
    }
//  SwiftUI側の状態が変わるたびに、UIKitのビューコントローラを更新して同期を取る。こっちは何度も使う。
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
//　NSObjectを継承することでCoodinatorがdelegateとなる。parentでCameraViewを連絡先に指定する
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }
//　撮った写真がUIImage型か確認して、parent.imageに代入する
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
        }
    }
}
