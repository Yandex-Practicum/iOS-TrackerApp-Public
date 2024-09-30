import UIKit

final class TrackerService {
    
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
    func trackerRecord(from entity: TrackerRecordEntity) -> TrackerRecord? {
        guard let id = entity.tracker?.id,
              let date = entity.date else {
            return nil
        }
        return TrackerRecord(trackerID: id, date: date)
    }

    // Получение трекеров на выбранную дату, с группировкой по категориям
//    func fetchTrackers(for date: Date) -> (trackersByCategory: [TrackerCategory], completedTrackers: [UUID: Bool]) {
//        let dayOfWeek = getDayOfWeek(from: date)
//        let trackerEntities = coreDataManager.fetchAllTrackersEntities()
//        
//        // Получаем все записи о выполнении на указанную дату
//        let completedRecords = coreDataManager.fetchAllRecordsForDate(date)
//        print("Найдено записей о выполнении: \(completedRecords.count) для даты: \(date)")
//        
//        var categoryDict: [String: [Tracker]] = [:]
//        var completedTrackers: [UUID: Bool] = [:]
//        
//        for trackerEntity in trackerEntities {
//            if let schedule = trackerEntity.schedule as? [String], schedule.contains(dayOfWeek) {
//                if let tracker = tracker(from: trackerEntity) {
//                    let categoryTitle = trackerEntity.category?.title ?? "Без категории"
//                    categoryDict[categoryTitle, default: []].append(tracker)
//                    
//                    // Проверяем, завершен ли трекер на эту дату
//                    let isCompleted = completedRecords.contains { $0.tracker?.id == tracker.id }
//                    completedTrackers[tracker.id] = isCompleted
//                    print("Трекер: \(tracker.name) завершен: \(isCompleted)")
//                }
//            }
//        }
//        
//        var trackerCategories: [TrackerCategory] = []
//        for (category, trackers) in categoryDict {
//            trackerCategories.append(TrackerCategory(title: category, trackers: trackers))
//        }
//        
//        return (trackersByCategory: trackerCategories, completedTrackers: completedTrackers)
//    }
    
    func fetchTrackers(for date: Date) -> (trackersByCategory: [TrackerCategory], completedTrackers: [UUID: Bool], completionCounts: [UUID: Int]) {
        let dayOfWeek = getDayOfWeek(from: date)
        let trackerEntities = coreDataManager.fetchAllTrackersEntities()
        
        // Получаем все записи о выполнении на указанную дату
        let completedRecords = coreDataManager.fetchAllRecordsForDate(date)
        print("Найдено записей о выполнении: \(completedRecords.count) для даты: \(date)")
        
        var categoryDict: [String: [Tracker]] = [:]
        var completedTrackers: [UUID: Bool] = [:]
        var completionCounts: [UUID: Int] = [:] // Словарь для хранения количества выполнений
        
        for trackerEntity in trackerEntities {
            if let schedule = trackerEntity.schedule as? [String], schedule.contains(dayOfWeek) {
                if let tracker = tracker(from: trackerEntity) {
                    let categoryTitle = trackerEntity.category?.title ?? "Без категории"
                    categoryDict[categoryTitle, default: []].append(tracker)
                    
                    // Проверяем, завершен ли трекер на эту дату
                    let isCompleted = completedRecords.contains { $0.tracker?.id == tracker.id }
                    completedTrackers[tracker.id] = isCompleted
                    
                    // Получаем количество завершений для трекера
                    let allRecordsForTracker = coreDataManager.fetchRecordsForTracker(trackerID: tracker.id)
                    let completionCount = allRecordsForTracker.count
                    completionCounts[tracker.id] = completionCount
                    
                    print("Трекер: \(tracker.name) завершен: \(isCompleted), количество выполнений: \(completionCount)")
                }
            }
        }
        
        var trackerCategories: [TrackerCategory] = []
        for (category, trackers) in categoryDict {
            trackerCategories.append(TrackerCategory(title: category, trackers: trackers))
        }
        
        return (trackersByCategory: trackerCategories, completedTrackers: completedTrackers, completionCounts: completionCounts)
    }

    func completeTracker(_ tracker: Tracker, on date: Date) {
        guard let trackerEntity = coreDataManager.fetchTrackerEntity(by: tracker.id) else {
            print("Трекер не найден")
            return
        }
        
        if let record = coreDataManager.addRecordEntity(for: trackerEntity, date: date) {
            print("Запись о выполнении трекера добавлена: \(record)")
        } else {
            print("Не удалось добавить запись о выполнении")
        }
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
    
    func countCompleted(for tracker: Tracker) -> Int {
        let records = coreDataManager.fetchRecordsForTracker(trackerID: tracker.id)
        return records.count
    }
}
