//
//  GenerationImageResponse.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/18.
//

import Foundation

struct GenerationImageResponse: Decodable {
    let created: Int
    private let data: [URLData]

    var url: URL? {
        guard let urlString = data.first?.url else { return nil }
        return URL(string: urlString)
    }

    struct URLData: Decodable {
        let url: String
    }
}
