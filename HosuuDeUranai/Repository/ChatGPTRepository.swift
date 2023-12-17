//
//  ChatGPTRepository.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/17.
//

import Foundation

protocol ChatGPTRepository {
    func fetchChatGPTResponse(chatRequest: ChatRequest) async throws -> ChatCompletionResponse
    func createImage(imageRequest: GenerateImageRequest) async throws -> GenerationImageResponse
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

    func createImage(imageRequest: GenerateImageRequest) async throws -> GenerationImageResponse {
        let url = URL(string: "https://api.openai.com/v1/images/generations")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(APIKey.chatGPT)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(imageRequest)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(GenerationImageResponse.self, from: data)
    }
}
