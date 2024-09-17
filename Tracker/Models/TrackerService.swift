import UIKit

class TrackerService {
    
    private let coreDataManager = CoreDataManager.shared
    
    // Преобразование TrackerEntity в Tracker
    func tracker(from entity: TrackerEntity) -> Tracker? {
        guard let id = entity.id,
              let name = entity.name,
              let colorData = entity.color,
              let color = UIColor.fromData(colorData),
              let emoji = entity.emoji,
              let schedule = entity.schedule as? [String] else {
            return nil
        }
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
    }

    // Преобразование TrackerCategoryEntity в TrackerCategory
    func trackerCategory(from entity: TrackerCategoryEntity, trackers: [Tracker]) -> TrackerCategory {
        return TrackerCategory(title: entity.title ?? "", trackers: trackers)
    }

    // Преобразование TrackerRecordEntity в TrackerRecord
//    func trackerRecord(from entity: TrackerRecordEntity) -> TrackerRecord? {
//        guard let id = entity.tracker?.id,
//              let date = entity.date else {
//            return nil
//        }
//        return TrackerRecord(trackerId: id, date: date)
//    }

    // Получение трекеров на выбранную дату, с группировкой по категориям
    func fetchTrackers(for date: Date) -> [TrackerCategory] {
        let dayOfWeek = getDayOfWeek(from: date)
        let trackerEntities = coreDataManager.fetchAllTrackersEntities()
        
        var categoryDict: [String: [Tracker]] = [:]
        
        for trackerEntity in trackerEntities {
            if let schedule = trackerEntity.schedule as? [String], schedule.contains(dayOfWeek) {
                if let tracker = tracker(from: trackerEntity) {
                    let categoryTitle = trackerEntity.category?.title ?? "Без категории"
                    categoryDict[categoryTitle, default: []].append(tracker)
                }
            }
        }
        
        var trackerCategories: [TrackerCategory] = []
        for (category, trackers) in categoryDict {
            trackerCategories.append(TrackerCategory(title: category, trackers: trackers))
        }
        return trackerCategories
    }

    // Логика поиска по имени
    func searchTrackers(with keyword: String) -> [Tracker] {
        let trackerEntities = coreDataManager.fetchAllTrackersEntities()
        return trackerEntities.compactMap { entity in
            if let tracker = tracker(from: entity),
               tracker.name.lowercased().contains(keyword.lowercased()) {
                return tracker
            }
            return nil
        }
    }
    
    // Вспомогательный метод для получения дня недели из даты
    private func getDayOfWeek(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
}
