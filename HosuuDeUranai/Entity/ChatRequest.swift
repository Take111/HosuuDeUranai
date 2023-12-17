//
//  ChatRequest.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/18.
//

import Foundation

struct ChatRequest: Encodable {
    let messages: [Message]
    let model: RequestModel = .todayComment
    let maxTokens: Int = 1000

    enum CodingKeys: String, CodingKey {
        case messages
        case model
        case maxTokens = "max_tokens"
    }

    enum RequestModel: String, Encodable {
        case todayComment = "gpt-3.5-turbo"
    }

    struct Message: Codable {
        let role: String
        let content: String
    }
}
