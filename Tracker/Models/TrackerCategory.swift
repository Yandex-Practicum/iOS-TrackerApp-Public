import Foundation

struct TrackerCategory: Hashable {
    let title: String // Заголовок категории
    let trackers: [Tracker] // Массив трекеров, относящихся к этой категории
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        return lhs.title == rhs.title && lhs.trackers == rhs.trackers
    }
}
