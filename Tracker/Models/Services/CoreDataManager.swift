import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    // MARK: - Работа с трекерами

    // Добавление нового трекера
    func addTrackerEntity(name: String, color: UIColor, emoji: String, schedule: [String], category: TrackerCategoryEntity) -> TrackerEntity? {
        let tracker = TrackerEntity(context: context)
        tracker.id = UUID()
        tracker.name = name
        tracker.color = color.toData()
        tracker.emoji = emoji
        tracker.schedule = schedule as NSObject
        tracker.category = category
        
        category.addToTrackers(tracker)
        
        do {
            try context.save()
            return tracker
        } catch {
            print("Ошибка при сохранении трекера: \(error)")
            return nil
        }
    }
    
    // Получение массива всех трекеров
    func fetchAllTrackersEntities() -> [TrackerEntity] {
        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка при загрузке трекеров: \(error)")
            return []
        }
    }
    
    func fetchTrackerEntity(by id: UUID) -> TrackerEntity? {
        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let trackers = try context.fetch(fetchRequest)
            return trackers.first
        } catch {
            print("Ошибка при загрузке трекера: \(error)")
            return nil
        }
    }
    
    // Удаление трекера
    func deleteTrackerEntity(_ tracker: TrackerEntity) {
        context.delete(tracker)
        do {
            try context.save()
        } catch {
            print("Ошибка при удалении трекера: \(error)")
        }
    }
    
    // MARK: - Работа с категориями

    func addCategoryEntity(title: String) -> TrackerCategoryEntity? {
        let category = TrackerCategoryEntity(context: context)
        category.title = title
        
        do {
            try context.save()
            return category
        } catch {
            print("Ошибка при сохранении категории: \(error)")
            return nil
        }
    }
    
    func fetchAllCategoriesEntities() -> [TrackerCategoryEntity] {
        let fetchRequest: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка при загрузке категорий: \(error)")
            return []
        }
    }
    
    func deleteCategoryEntity(_ category: TrackerCategoryEntity) {
        context.delete(category)
        do {
            try context.save()
        } catch {
            print("Ошибка при удалении категории: \(error)")
        }
    }

    // MARK: - Работа с записями о выполнении трекеров

    func addRecordEntity(for tracker: TrackerEntity, date: Date) -> TrackerRecordEntity? {
        let record = TrackerRecordEntity(context: context)
        record.tracker = tracker
        record.date = date

        do {
            try context.save()
            print("Запись о выполнении добавлена: трекер \(tracker.id ?? UUID()) на дату \(date)")
            return record
        } catch {
            print("Ошибка при сохранении записи о выполнении: \(error)")
            return nil
        }
    }
    
    func fetchAllRecordsEntities() -> [TrackerRecordEntity] {
        let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        
        do {
            let records = try context.fetch(fetchRequest)
            return records
        } catch {
            print("Ошибка при загрузке записей: \(error)")
            return []
        }
    }
    
    func fetchAllRecordsForDate(_ date: Date) -> [TrackerRecordEntity] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        
        let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay! as NSDate)

        do {
            let records = try context.fetch(fetchRequest)
            print("Найдено записей о выполнении: \(records.count) для даты: \(date)")
            return records
        } catch {
            print("Ошибка при получения записей: \(error)")
            return []
        }
    }
    
    func fetchRecordsForTracker(trackerID: UUID) -> [TrackerRecordEntity] {
        let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.id == %@", trackerID as CVarArg)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка получения записей для трекера: \(error)")
            return []
        }
    }
    
    func deleteRecordEntity(_ record: TrackerRecordEntity) {
        context.delete(record)
        do {
            try context.save()
        } catch {
            print("Ошибка при удалении записи: \(error)")
        }
    }
}

// MARK: - Расширения для сериализации UIColor

extension UIColor {
    func toData() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }

    static func fromData(_ data: Data) -> UIColor? {
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
        } catch {
            print("Ошибка при распаковке цвета: \(error)")
            return nil
        }
    }
}
