//
//  ScheduleStorage.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import Foundation

final class ScheduleStorage {
    static let shared = ScheduleStorage()

    private let userDefaults = UserDefaults.standard

    private enum Keys {
        static let hour = "scheduledHour"
        static let minute = "scheduledMinute"
        static let second = "scheduledSecond"
        static let totalSeconds = "scheduledTotalSeconds"
    }

    private init() {}

    // MARK: - Save

    func saveSchedule(hour: Int, minute: Int, second: Int) -> Int {
        let total = (hour * 3600) + (minute * 60) + second

        userDefaults.set(hour, forKey: Keys.hour)
        userDefaults.set(minute, forKey: Keys.minute)
        userDefaults.set(second, forKey: Keys.second)
        userDefaults.set(total, forKey: Keys.totalSeconds)

        return total
    }

    // MARK: - Load

    func getScheduledHour() -> Int {
        userDefaults.integer(forKey: Keys.hour)
    }

    func getScheduledMinute() -> Int {
        userDefaults.integer(forKey: Keys.minute)
    }

    func getScheduledSecond() -> Int {
        userDefaults.integer(forKey: Keys.second)
    }

    func getTotalSeconds() -> Int {
        userDefaults.integer(forKey: Keys.totalSeconds)
    }

    // MARK: - Clear

    func clearSchedule() {
        userDefaults.removeObject(forKey: Keys.hour)
        userDefaults.removeObject(forKey: Keys.minute)
        userDefaults.removeObject(forKey: Keys.second)
        userDefaults.removeObject(forKey: Keys.totalSeconds)
    }
}
