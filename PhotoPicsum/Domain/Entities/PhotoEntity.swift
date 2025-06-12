//
//  PhotoEntity.swift
//  PhotoPicsum
//
//  Created by ThienTran on 11/6/25.
//

import Foundation

struct PhotoEntity: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String

    var sizeDescription: String {
        return "\(width)x\(height)"
    }

    var aspectRatio: CGFloat {
        return CGFloat(height) / CGFloat(width)
    }
}
