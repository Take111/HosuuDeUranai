//
//  ChatCompletionResponse.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/18.
//

import Foundation

struct ChatCompletionResponse: Codable {
    let choices: [Choice]
    let created: Int
    let id: String
    let model: String
    let object: String
    let usage: Usage

    struct Choice: Codable {
        let finishReason: String
        let index: Int
        let message: Message
        let logprobs: String?

        enum CodingKeys: String, CodingKey {
            case finishReason = "finish_reason"
            case index
            case message
            case logprobs
        }

        struct Message: Codable {
            let content: String
            let role: String
        }
    }

    struct Usage: Codable {
        let completionTokens: Int
        let promptTokens: Int
        let totalTokens: Int

        enum CodingKeys: String, CodingKey {
            case completionTokens = "completion_tokens"
            case promptTokens = "prompt_tokens"
            case totalTokens = "total_tokens"
        }
    }
}
