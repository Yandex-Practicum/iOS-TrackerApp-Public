//
//  Tracker.swift
//  Tracker
//
//  Created by Sergey Ivanov on 06.09.2024.
//

import UIKit

struct Tracker {
    let id: UUID // Уникальный идентификатор трекера
    let name: String // Название трекера
    let color: UIColor // Цвет трекера
    let emoji: String // Эмодзи трекера
    let schedule: [String] // Расписание, например, ["Пн", "Ср", "Пт"] или другие дни недели
}
