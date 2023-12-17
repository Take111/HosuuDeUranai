//
//  ChatGPTUseCase.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/17.
//

import Foundation
import UserNotifications

protocol ChatGPTUseCase {
    func fetchTodayUranaiIfPossible(stepCount: Int, stepCountRange: StepCountRange) async -> String?
    func fetchTodayImageUrlIfPossible(stepCountRange: StepCountRange) async -> URL?
}

final class ChatGPTUseCaseImpl: ChatGPTUseCase {

    private let repository: ChatGPTRepository

    init(repository: ChatGPTRepository = ChatGPTRepositoryImpl()) {
        self.repository = repository
    }

    func fetchTodayUranaiIfPossible(stepCount: Int, stepCountRange: StepCountRange) async -> String? {
        // 21時以降であれば実行する
        guard Calendar.current.component(.hour, from: Date()) >= 21 else { return nil }
        do {
            let chatRequest = ChatRequest(messages: [
                .init(role: "system", content: "あなたは占い師で、歩数に応じて相手を罵倒したり褒めちぎることができます。"),
                .init(role: "user", content: "今日の歩数は\(stepCount)歩でした。\(stepCountRange.prompt)"),
            ])
            let response = try await repository.fetchChatGPTResponse(chatRequest: chatRequest)
            return response.choices.first?.message.content ?? ""
        } catch {
            return "エラーが発生しました"
        }
    }

    func fetchTodayImageUrlIfPossible(stepCountRange: StepCountRange) async -> URL? {
        // 21時以降であれば実行する
        guard Calendar.current.component(.hour, from: Date()) >= 21 else { return nil }
        do {
            let imageRequest = GenerateImageRequest(prompt: "パワハラ部長のような威圧的な画像をください")
            let response = try await repository.createImage(imageRequest: imageRequest)
            return response.url
        } catch {
            return nil
        }
    }
}
