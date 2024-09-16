import CoreData
import UIKit

class CoreDataManager {
    
    // Singleton для удобного доступа к Core Data менеджеру
    static let shared = CoreDataManager()
    
    // Ссылка на NSPersistentContainer из AppDelegate
    let persistentContainer: NSPersistentContainer
    
    // Контекст Core Data
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Инициализация Core Data контейнера
    private init() {
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    // MARK: - Работа с трекерами

    // Добавление нового трекера
    func addTracker(name: String, color: UIColor, emoji: String, schedule: [String], category: TrackerCategoryEntity) -> TrackerEntity? {
        let tracker = TrackerEntity(context: context)
        tracker.id = UUID()
        tracker.name = name
        tracker.color = color.toData() // Сериализация UIColor в Data
        tracker.emoji = emoji
        tracker.schedule = schedule as NSObject // Преобразование расписания в объект
        tracker.category = category // Связь с категорией
        
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
    func fetchTrackers() -> [TrackerEntity] {
        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        
        do {
            let trackers = try context.fetch(fetchRequest)
            return trackers
        } catch {
            print("Ошибка при загрузке трекеров: \(error)")
            return []
        }
    }

    // Загрузка трекеров по дате
    func fetchTrackers(for date: Date) -> [TrackerEntity] {
        let dayOfWeek = getDayOfWeek(from: date)
        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        
        // Фильтруем трекеры по расписанию
        fetchRequest.predicate = NSPredicate(format: "schedule CONTAINS %@", dayOfWeek)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка при загрузке трекеров: \(error)")
            return []
        }
    }

    // Удаление трекера
    func deleteTracker(_ tracker: TrackerEntity) {
        context.delete(tracker)
        do {
            try context.save()
        } catch {
            print("Ошибка при удалении трекера: \(error)")
        }
    }
    
    // MARK: - Работа с категориями

    // Добавление новой категории
    func addCategory(title: String) -> TrackerCategoryEntity? {
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

    // Загрузка всех категорий
    func fetchCategories() -> [TrackerCategoryEntity] {
        let fetchRequest: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            return categories
        } catch {
            print("Ошибка при загрузке категорий: \(error)")
            return []
        }
    }
    
    // Удаление категории
    func deleteCategory(_ category: TrackerCategoryEntity) {
        context.delete(category)
        do {
            try context.save()
        } catch {
            print("Ошибка при удалении категории: \(error)")
        }
    }

    // MARK: - Работа с записями о выполнении трекеров

    // Добавление записи о выполнении трекера
    func addRecord(for tracker: TrackerEntity, date: Date) -> TrackerRecordEntity? {
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

    // Загрузка всех записей на выбранную дату
    func fetchRecords(for date: Date) -> [TrackerRecordEntity] {
        let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        
        // Фильтрация записей по дате
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка при загрузке записей: \(error)")
            return []
        }
    }

    // Удаление записи о выполнении трекера
    func deleteRecord(_ record: TrackerRecordEntity) {
        context.delete(record)
        do {
            try context.save()
        } catch {
            print("Ошибка при удалении записи: \(error)")
        }
    }
    
    // MARK: - Вспомогательные методы
    
    // Получаем день недели из даты
    private func getDayOfWeek(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
}

// MARK: - Расширения для сериализации UIColor

extension UIColor {
    // Сериализация UIColor в Data
    func toData() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }

    // Десериализация UIColor из Data с использованием нового метода
    static func fromData(_ data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}
