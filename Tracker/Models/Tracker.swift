import UIKit

struct Tracker: Hashable {
    let id: UUID // Уникальный идентификатор трекера
    let name: String // Название трекера
    let color: UIColor // Цвет трекера
    let emoji: String // Эмодзи трекера
    let schedule: [String] // Расписание, например, ["Пн", "Ср", "Пт"] или другие дни недели
    
    static func == (lhs: Tracker, rhs: Tracker) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.color == rhs.color &&
               lhs.emoji == rhs.emoji &&
               lhs.schedule == rhs.schedule
    }

    // Реализация Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
