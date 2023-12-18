//
//  HomeViewModel.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/17.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {

    private let chatGPTUseCase: ChatGPTUseCase
    private let notificationUseCase: NotificationUseCase
    private let healhkitUseCase: HealthKitUseCase

    @Published private(set) var todayComment: String = ""
    @Published private(set) var todaImageUrl: URL?
    @Published private(set) var showSuccessView: Bool = false
    @Published private(set) var isLoading: Bool = false

    init() {
        chatGPTUseCase = ChatGPTUseCaseImpl()
        notificationUseCase = NotificationUseCaseImpl()
        healhkitUseCase = HealthKitUseCaseImpl()

        healhkitUseCase.requestAuthorizationIfNeeded { [weak self] success in
            guard success else { return }
            self?.isLoading = true
            self?.fetchStepCount()
            self?.requestNotification()
        }
    }

    private func requestNotification() {
        notificationUseCase.requestAuthorizationIfNeeded { [weak self] isGranted in
            guard isGranted else { return }
            self?.notificationUseCase.setLocalNotificationIfNeeded()
        }
    }

    private func fetchStepCount() {
        healhkitUseCase.fetchTodayStepCount {[weak self] result in
            switch result {
            case .success(let count):
                self?.fetchCommentAndImage(stepCount: count)
            case .failure:
                return
            }
        }
    }

    private func fetchCommentAndImage(stepCount: Int) {
        let range = StepCountRange(stepCount: stepCount)
        Task {
            self.isLoading = false
            // 1秒待つ
            self.showSuccessView = true
            try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
            self.showSuccessView = false

            for try await result in self.chatGPTUseCase.fetchTalkStreaming(stepCount: stepCount, stepCountRange: range) {
                DispatchQueue.main.async {
                    self.todayComment += result.choices.first?.delta.content ?? ""
                }
            }

            self.todaImageUrl = await self.chatGPTUseCase.fetchTodayImageUrlIfPossible(stepCountRange: range)
        }
    }
}
