//
//  ChatGPTRepository.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/17.
//

import Foundation

protocol ChatGPTRepository {
    func fetchChatGPTResponse(chatRequest: ChatRequest) async throws -> ChatCompletionResponse
}

final class ChatGPTRepositoryImpl: ChatGPTRepository {

    func fetchChatGPTResponse(chatRequest: ChatRequest) async throws -> ChatCompletionResponse {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(APIKey.chatGPT)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(chatRequest)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
    }
}
struct ChatRequest: Encodable {
    let messages: [Message]
    let model: RequestModel = .todayComment
    let maxTokens: Int = 1000

    enum CodingKeys: String, CodingKey {
        case messages
        case model
        case maxTokens = "max_tokens"
    }

    struct Message: Codable {
        let role: String
        let content: String
    }
}

enum RequestModel: String, Encodable {
    case todayComment = "gpt-3.5-turbo"
}

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
