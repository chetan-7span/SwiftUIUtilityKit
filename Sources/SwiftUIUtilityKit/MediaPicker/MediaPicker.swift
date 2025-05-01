//
//  MediaPicker.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 04/04/25.
//

import SwiftUI
import PhotosUI

public struct MediaPicker: UIViewControllerRepresentable {
    public var mediaType: MediaType
    public var isCropEnabled: Bool
    public var onMediaPicked: (PickedMedia) -> Void

    public init(
        mediaType: MediaType,
        isCropEnabled: Bool = false,
        onMediaPicked: @escaping (PickedMedia) -> Void
    ) {
        self.mediaType = mediaType
        self.isCropEnabled = isCropEnabled
        self.onMediaPicked = onMediaPicked
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        if isCropEnabled && mediaType == .photo {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true // enables cropping UI
            imagePicker.delegate = context.coordinator
            return imagePicker
        } else {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            switch mediaType {
            case .photo: config.filter = .images
            case .video: config.filter = .videos
            case .both:  config.filter = .any(of: [.images, .videos])
            }
            config.selectionLimit = 1

            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(onMediaPicked: onMediaPicked, isCropEnabled: isCropEnabled)
    }

    public class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let onMediaPicked: (PickedMedia) -> Void
        let isCropEnabled: Bool

        init(onMediaPicked: @escaping (PickedMedia) -> Void, isCropEnabled: Bool) {
            self.onMediaPicked = onMediaPicked
            self.isCropEnabled = isCropEnabled
        }

        // MARK: - PHPicker Delegate
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let item = results.first else { return }

            if item.itemProvider.canLoadObject(ofClass: UIImage.self) {
                item.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.onMediaPicked(PickedMedia(image: image, type: .photo))
                        }
                    }
                }
            } else if item.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                item.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                    guard let url = url else { return }
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                    try? FileManager.default.copyItem(at: url, to: tempURL)
                    DispatchQueue.main.async {
                        self.onMediaPicked(PickedMedia(videoURL: tempURL, type: .video))
                    }
                }
            }
        }

        // MARK: - UIImagePicker Delegate
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

        public func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            picker.dismiss(animated: true)

            if let croppedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.onMediaPicked(PickedMedia(image: croppedImage, type: .photo))
                }
            }
        }
    }
}
