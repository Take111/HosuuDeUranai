//
//  StepCountRange.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/18.
//

import Foundation

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
        case .veryHigh:
            return "あなたの運命は大吉ですから始めて、最高にすごいので、人生最大級くらいの褒め言葉を送ってください。実際の名言を教えて欲しい。今日1日を幸せに終わりたい"
        case .high:
            return "あなたの運命は中吉ですから始めて、少し良いので、ちょっとだけ褒めてください。最後に人生の格言みたいなことを言ってください"
        case .middle:
            return "あなたの運命は小吉ですから始めて、まあまあなので、適当に人生の格言っぽいことを言ってください"
        case .low:
            return "あなたの運命は凶ですから始めて、あんまり良くないので、ちょっと罵倒してください。あと適当に人生の格言っぽいことを言ってください"
        case .veryLow:
            return "あなたの運命は大凶ですから始めて、話にならないくらい罵倒してパワハラ上司並みに詰めてください。"
        }
    }

    var imagePrompt: String {
        switch self {
        case .veryHigh:
            return "大吉の文字が画像に入って、天国のような画像を作成してください"
        case .high:
            return "中吉の文字が画像に入って、少し幸せな画像を作成してください"
        case .middle:
            return "小吉の文字が画像に入って、普通の画像を作成してください"
        case .low:
            return "凶の文字が画像に入って、少し怖い画像を作成してください"
        case .veryLow:
            return "大凶の文字が画像に入って、ピザの画像を作成してください"
        }
    }
}
