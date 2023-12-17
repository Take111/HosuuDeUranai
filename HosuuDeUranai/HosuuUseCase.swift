//
//  HosuuUseCase.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/17.
//

import Foundation
import UserNotifications

protocol HosuuUseCase {
    func fetchTodayUranaiIfPossible(stepCount: Int, stepCountRange: StepCountRange) async -> String?
    func fetchTodayImageUrlIfPossible() async -> URL?
    func setLocalNotificationIfNeeded()
}

final class HosuuUseCaseImpl: HosuuUseCase {

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

    func fetchTodayImageUrlIfPossible() async -> URL? {
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

    func setLocalNotificationIfNeeded() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            if requests.isEmpty {
                // 毎日21時にローカルプッシュを送信する
                let content = UNMutableNotificationContent()
                content.title = "今日の運勢は？"
                content.body = "今日の運勢はどうだったかな？チェックしよう"
                content.sound = UNNotificationSound.default
                var dateComponents = DateComponents()
                dateComponents.hour = 21
                dateComponents.minute = 00
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "dailyUranai", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}
