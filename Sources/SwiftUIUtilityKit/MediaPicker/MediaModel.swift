//
//  MediaModel.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 04/04/25.
//

import Foundation
import AVFoundation
import PhotosUI

public struct PickedMedia {
    public let image: UIImage?
    public let videoURL: URL?
    public let type: MediaType

    public init(image: UIImage? = nil, videoURL: URL? = nil, type: MediaType) {
        self.image = image
        self.videoURL = videoURL
        self.type = type
    }
}


