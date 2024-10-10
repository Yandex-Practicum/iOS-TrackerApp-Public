import UIKit

final class TrackerService: NSObject {
    
    private let trackerStore: TrackerStore
    private let categoryStore: TrackerCategoryStore
    private let recordStore: TrackerRecordStore
    
    // Замыкание для обновления данных при изменении
    var onTrackersUpdated: (() -> Void)?
        
    init(trackerStore: TrackerStore, categoryStore: TrackerCategoryStore, recordStore: TrackerRecordStore) {
        self.trackerStore = trackerStore
        self.categoryStore = categoryStore
        self.recordStore = recordStore
        super.init()
        
        // Подписываемся на изменения данных из TrackerStore
        trackerStore.onTrackersChanged = { [weak self] in
            self?.onTrackersUpdated?()
        }
    }
    
    func fetchAllTrackers() -> [Tracker] {
        return trackerStore.fetchAllTrackers()
    }
    
    // Получение трекеров для конкретной даты
    func fetchTrackers(for date: Date) -> (trackersByCategory: [TrackerCategory], completedTrackers: [UUID: Bool], completionCounts: [UUID: Int]) {
        let dayOfWeek = getDayOfWeek(from: date)
        let trackers = trackerStore.fetchAllTrackers()
        
        // Получаем все записи о выполнении на указанную дату
        let completedRecords = recordStore.fetchRecords(for: date)
        
        var categoryDict: [String: [Tracker]] = [:]
        var completedTrackers: [UUID: Bool] = [:]
        var completionCounts: [UUID: Int] = [:]
        
        for tracker in trackers {
            let isRegular = !tracker.schedule.isEmpty  // Регулярное событие, если расписание не пустое
            
            if isRegular {
                // Логика для регулярных событий
                if tracker.schedule.contains(dayOfWeek) {
                    addToCategory(tracker: tracker, categoryDict: &categoryDict, completedTrackers: &completedTrackers, isCompleted: completedRecords.contains { $0.trackerID == tracker.id })
                }
            } else {
                // Логика для нерегулярных событий
                let allRecordsForTracker = recordStore.fetchAllRecords().filter { $0.trackerID == tracker.id }
                
                if let lastCompletionDate = allRecordsForTracker.last?.date {
                    // Если нерегулярное событие завершено, отображаем только в день завершения
                    //if lastCompletionDate == date {
                    if Calendar.current.isDate(lastCompletionDate, inSameDayAs: date) {
                        addToCategory(tracker: tracker, categoryDict: &categoryDict, completedTrackers: &completedTrackers, isCompleted: true)
                    }
                } else {
                    // Если событие еще не завершено, отображаем каждый день
                    addToCategory(tracker: tracker, categoryDict: &categoryDict, completedTrackers: &completedTrackers, isCompleted: false)
                }
            }
            
            // Подсчитываем количество выполнений трекера
            let completionCount = recordStore.fetchAllRecords().filter { $0.trackerID == tracker.id }.count
            completionCounts[tracker.id] = completionCount
        }
        
        var trackerCategories: [TrackerCategory] = []
        for (category, trackers) in categoryDict {
            trackerCategories.append(TrackerCategory(title: category, trackers: trackers))
        }
        
        return (trackersByCategory: trackerCategories, completedTrackers: completedTrackers, completionCounts: completionCounts)
    }

    private func addToCategory(tracker: Tracker, categoryDict: inout [String: [Tracker]], completedTrackers: inout [UUID: Bool], isCompleted: Bool) {
        let categoryTitle = categoryStore.fetchAllCategories().first(where: { category in
            category.trackers.contains(where: { $0.id == tracker.id })
        })?.title ?? "Без категории"
        
        categoryDict[categoryTitle, default: []].append(tracker)
        completedTrackers[tracker.id] = isCompleted
    }

    func completeTracker(_ tracker: Tracker, on date: Date) {
        recordStore.addRecord(for: tracker, date: date)
        
        // Проверка, что запись сохранена
        let savedRecords = recordStore.fetchAllRecords().filter { $0.trackerID == tracker.id }
        print("Записаны данные для трекера \(tracker.name): \(savedRecords)")
    }

    // Логика поиска по имени
    func searchTrackers(with keyword: String) -> [Tracker] {
        return trackerStore.fetchAllTrackers().filter { $0.name.lowercased().contains(keyword.lowercased()) }
    }
    
    // Вспомогательный метод для получения дня недели из даты
    private func getDayOfWeek(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
    
    func countCompleted(for tracker: Tracker) -> Int {
        return recordStore.fetchAllRecords().filter { $0.trackerID == tracker.id }.count
    }
}
