import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    // MARK: - Работа с трекерами (CRUD)

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
    
    // Загрузка всех трекеров
    func fetchAllTrackersEntities() -> [TrackerEntity] {
        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка при загрузке трекеров: \(error)")
            return []
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
    
    // MARK: - Работа с категориями (CRUD)

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

    // MARK: - Работа с записями о выполнении трекеров (CRUD)

    func addRecordEntity(for tracker: TrackerEntity, date: Date) -> TrackerRecordEntity? {
        let record = TrackerRecordEntity(context: context)
        record.tracker = tracker
        record.date = date
        
        do {
            try context.save()
            return record
        } catch {
            print("Ошибка при сохранении записи: \(error)")
            return nil
        }
    }
    
    func fetchRecordsEntities(for date: Date) -> [TrackerRecordEntity] {
        let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка при загрузке записей: \(error)")
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

//extension UIColor {
//    // Сериализация UIColor в Data
//    func toData() -> Data? {
//        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
//    }
//
//    // Десериализация UIColor из Data
//    static func fromData(_ data: Data) -> UIColor? {
//        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
//    }
//}

extension UIColor {
    func toData() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }

    static func fromData(_ data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}
