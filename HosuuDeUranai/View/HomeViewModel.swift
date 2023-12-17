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

    init() {
        chatGPTUseCase = ChatGPTUseCaseImpl()
        notificationUseCase = NotificationUseCaseImpl()
        healhkitUseCase = HealthKitUseCaseImpl()

        healhkitUseCase.requestAuthorizationIfNeeded { [weak self] success in
            guard success else { return }
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
            let (commentValue, imageValue) = await (self.chatGPTUseCase.fetchTodayUranaiIfPossible(stepCount: stepCount, stepCountRange: range), self.chatGPTUseCase.fetchTodayImageUrlIfPossible(stepCountRange: range))

            self.todayComment = commentValue ?? "今日の結果はまだないよ!\n夜9時に占うね"
            self.todaImageUrl = imageValue
        }
    }
}
