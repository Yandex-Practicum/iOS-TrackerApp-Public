import CoreData
import UIKit

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {

    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerEntity>?

    var onTrackersChanged: (() -> Void)?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }

    // Добавление нового трекера
    func addTracker(name: String, color: UIColor, emoji: String, schedule: [String], category: TrackerCategory) -> Tracker? {
        let trackerEntity = TrackerEntity(context: context)
        trackerEntity.id = UUID()
        trackerEntity.name = name
        trackerEntity.color = color
        trackerEntity.emoji = emoji
        trackerEntity.schedule = schedule as NSObject

        if let categoryEntity = fetchCategoryEntity(for: category) {
            trackerEntity.category = categoryEntity
        }

        do {
            try context.save()
            return Tracker(id: trackerEntity.id!, name: name, color: color, emoji: emoji, schedule: schedule)
        } catch {
            print("Ошибка при сохранении трекера: \(error)")
            return nil
        }
    }

    // Выполнение fetch для обновления данных
    func performFetch() {
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Ошибка при выполнении fetch: \(error)")
        }
    }
    
    // Метод делегата для уведомления об изменениях в данных
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        onTrackersChanged?()  // Вызываем замыкание, когда данные изменяются
    }
    
    // Получение всех трекеров в модели структуры Tracker
//    func fetchAllTrackers() -> [Tracker] {
//        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
//        do {
//            let trackerEntities = try context.fetch(fetchRequest)
//            return trackerEntities.compactMap { tracker(from: $0) }
//        } catch {
//            print("Ошибка при загрузке трекеров: \(error)")
//            return []
//        }
//    }
    func fetchAllTrackers() -> [Tracker] {
        guard let trackerEntities = fetchedResultsController?.fetchedObjects else { return [] }
        return trackerEntities.compactMap { tracker(from: $0) }
    }

    // Настройка FetchedResultsController
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        // Назначаем делегат
        fetchedResultsController?.delegate = self

        // Выполняем начальное получение данных
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Ошибка при загрузке трекеров: \(error)")
        }
    }
    
    // Поиск категории по модели TrackerCategory
    private func fetchCategoryEntity(for category: TrackerCategory) -> TrackerCategoryEntity? {
        let fetchRequest: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", category.title)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Ошибка при загрузке категории: \(error)")
            return nil
        }
    }
}

extension TrackerStore {
    // Преобразование TrackerEntity в Tracker
    private func tracker(from entity: TrackerEntity) -> Tracker? {
        guard let id = entity.id,
              let name = entity.name,
              let colorData = entity.color,
              let color = entity.color as? UIColor,
              let emoji = entity.emoji,
              let schedule = entity.schedule as? [String] else {
            return nil
        }
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
    }
}
