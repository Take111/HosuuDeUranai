//
//  NotificationUseCase.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/18.
//

import Foundation
import UserNotifications

protocol NotificationUseCase { 
    func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void)
    func setLocalNotificationIfNeeded()
}

final class NotificationUseCaseImpl: NotificationUseCase {

    func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {[weak self] granted, error in
            guard let self else { return }
            if granted {
                completion(true)
            } else {
                completion(false)
            }
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
