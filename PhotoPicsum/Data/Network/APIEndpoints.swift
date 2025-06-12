//
//  APIEndpoints.swift
//  PhotoPicsum
//
//  Created by ThienTran on 11/6/25.
//

import Foundation

struct APIEndpoints {
    //Base URL
    static func photos(page: Int, limit: Int) -> URL? {
      return URL(string: "\(Constant.baseURL)=\(page)&limit=\(limit)")
    }
}
