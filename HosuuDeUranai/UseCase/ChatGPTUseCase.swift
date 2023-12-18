//
//  ChatGPTUseCase.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/17.
//

import Foundation
import OpenAI

protocol ChatGPTUseCase {
    func fetchTodayImageUrlIfPossible(stepCountRange: StepCountRange) async -> URL?
    func fetchTalkStreaming(stepCount: Int, stepCountRange: StepCountRange) -> AsyncThrowingStream<ChatStreamResult, Error>
}

final class ChatGPTUseCaseImpl: ChatGPTUseCase {

    private let repository: ChatGPTRepository

    init(repository: ChatGPTRepository = ChatGPTRepositoryImpl()) {
        self.repository = repository
    }

    func fetchTodayImageUrlIfPossible(stepCountRange: StepCountRange) async -> URL? {
        // 21時以降であれば実行する
        guard Calendar.current.component(.hour, from: Date()) >= 21 else { return nil }
        do {
            let result = try await repository.createImage(imagesQuery: .init(prompt: stepCountRange.imagePrompt, n: 1, size: "512x512"))
            return URL(string: result.data.first?.url ?? "")
        } catch {
            return nil
        }
    }

    func fetchTalkStreaming(stepCount: Int, stepCountRange: StepCountRange) -> AsyncThrowingStream<ChatStreamResult, Error> {
        repository.fetchTalkStreaming(chatQuery: .init(model: .gpt3_5Turbo, messages: [.init(role: .system, content: "あなたは占い師で、歩数に応じて相手を罵倒したり褒めちぎることができます。"), .init(role: .user, content: "今日の歩数は\(stepCount)歩でした。\(stepCountRange.prompt)")]))
    }
}
