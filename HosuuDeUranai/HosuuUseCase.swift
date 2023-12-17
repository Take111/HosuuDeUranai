//
//  HosuuUseCase.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/17.
//

import Foundation

protocol HosuuUseCase {
    func fetchTodayUranai(stepCount: Int, stepCountRange: StepCountRange) async -> String
}

final class HosuuUseCaseImpl: HosuuUseCase {

    private let repository: ChatGPTRepository

    init(repository: ChatGPTRepository = ChatGPTRepositoryImpl()) {
        self.repository = repository
    }

    func fetchTodayUranai(stepCount: Int, stepCountRange: StepCountRange) async -> String {
        do {
            let chatRequest = ChatRequest(messages: [
                .init(role: "system", content: "あなたは占い師で、歩数に応じて相手を罵倒したり褒めちぎることができます。"),
                .init(role: "user", content: "今日の歩数は\(stepCount)歩でした。\(stepCountRange.prompt)"),
            ])
            let response = try await repository.fetchChatGPTResponse(chatRequest: chatRequest)
            return response.choices.first?.message.content ?? ""
        } catch {
            return ""
        }
    }
}
