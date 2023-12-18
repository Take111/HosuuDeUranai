//
//  ChatGPTRepository.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/17.
//

import Foundation
import OpenAI

protocol ChatGPTRepository {
    func createImage(imagesQuery: ImagesQuery) async throws -> ImagesResult
    func fetchTalkStreaming(chatQuery: ChatQuery) -> AsyncThrowingStream<ChatStreamResult, Error>
}

final class ChatGPTRepositoryImpl: ChatGPTRepository {

    private let openAI = OpenAI(apiToken: APIKey.chatGPT)

    func createImage(imagesQuery: ImagesQuery) async throws -> ImagesResult {
        try await openAI.images(query: imagesQuery)
    }

    func fetchTalkStreaming(chatQuery: ChatQuery) -> AsyncThrowingStream<ChatStreamResult, Error> {
        openAI.chatsStream(query: chatQuery)
    }
}
