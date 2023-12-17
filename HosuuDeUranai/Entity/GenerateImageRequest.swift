//
//  GenerateImageRequest.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/18.
//

import Foundation

struct GenerateImageRequest: Encodable {
    let prompt: String
    let n: Int = 1
    let size: String = "512x512"

    enum CodingKeys: String, CodingKey {
        case prompt
    }
}
