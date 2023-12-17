//
//  HealthKitUseCase.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/18.
//

import Foundation
import HealthKit

protocol HealthKitUseCase {
    func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void)
    func fetchTodayStepCount(completion: @escaping (Result<Int, Error>) -> Void)
}

final class HealthKitUseCaseImpl: HealthKitUseCase {

    private let healthStore: HKHealthStore

    init() {
        self.healthStore = HKHealthStore()
    }

    func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void) {
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        healthStore.requestAuthorization(toShare: [], read: allTypes) {[weak self] success, error in
            guard let self else { return }
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func fetchTodayStepCount(completion: @escaping (Result<Int, Error>) -> Void) {
        // 当日の今までの歩数を取得する
        let distanceType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate) { query, statistics, error in
            guard let stepCount = statistics?.sumQuantity()?.doubleValue(for: HKUnit.count()) else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(Int(stepCount)))
        }
        healthStore.execute(query)
    }
}
