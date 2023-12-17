//
//  HomeViewModel.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/17.
//

import Foundation
import HealthKit
import UserNotifications

@MainActor
final class HomeViewModel: ObservableObject {

    // HealthKit
    private let healthStore: HKHealthStore
    private let useCase: HosuuUseCase

    @Published private(set) var todayComment: String = ""
    @Published private(set) var todaImageUrl: URL?

    init() {
        healthStore = HKHealthStore()
        useCase = HosuuUseCaseImpl()
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        healthStore.requestAuthorization(toShare: [], read: allTypes) {[weak self] success, error in
            guard let self else { return }
            if success {
                fetchStepCount()
                requestNotification()
            }
        }
    }

    private func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {[weak self] granted, error in
            guard let self else { return }
            if granted {
                useCase.setLocalNotificationIfNeeded()
            }
        }
    }

    private func fetchStepCount() {
        // 当日の今までの歩数を取得する
        let distanceType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate) { [weak self] query, statistics, errir in
            guard let self, let stepCount = statistics?.sumQuantity()?.doubleValue(for: HKUnit.count()) else { return }
            fetchCommentAndImage(stepCount: Int(stepCount))
        }
        healthStore.execute(query)
    }

    private func fetchCommentAndImage(stepCount: Int) {
        Task {
            let (commentValue, imageValue) = await (self.useCase.fetchTodayUranaiIfPossible(stepCount: stepCount, stepCountRange: StepCountRange(stepCount: stepCount)), self.useCase.fetchTodayImageUrlIfPossible())

            self.todayComment = commentValue ?? "今日の結果はまだないよ!\n夜9時に占うね"
            self.todaImageUrl = imageValue
        }
    }
}

enum StepCountRange {
    case veryHigh
    case high
    case middle
    case low
    case veryLow

    init(stepCount: Int) {
        switch stepCount {
        case 0...100:
            self = .veryLow
        case 101...1000:
            self = .low
        case 1001...3000:
            self = .middle
        case 3001...6000:
            self = .high
        default:
            self = .veryHigh
        }
    }

    var prompt: String {
        switch self {
        case .veryLow:
            return "話にならないくらい悪いので、全く今の若者は、、みたいなだるい絡みをするパワハラ上司並みに詰めて異常に罵倒してください。"
        case .low:
            return "あんまり良くないので、ちょっと罵倒してください。あと適当に人生の格言っぽいことを言ってください"
        case .middle:
            return "まあまあなので、適当に人生の格言っぽいことを言ってください"
        case .high:
            return "少し良いので、ちょっとだけ褒めてください。最後に人生の格言みたいなことを言ってください"
        case .veryHigh:
            return "最高にすごいので、人生最大級くらいの褒め言葉を送ってください。実際の名言を教えて欲しい。今日1日を幸せに終わりたい"
        }
    }
}
