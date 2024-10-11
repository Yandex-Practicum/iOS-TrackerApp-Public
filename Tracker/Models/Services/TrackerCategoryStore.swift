import CoreData

final class TrackerCategoryStore {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Добавление новой категории
    func addCategory(title: String) -> TrackerCategory? {
        let categoryEntity = TrackerCategoryEntity(context: context)
        categoryEntity.title = title
        
        do {
            try context.save()
            return TrackerCategory(title: title, trackers: [])
        } catch {
            print("Ошибка при сохранении категории: \(error)")
            return nil
        }
    }

    // Получение всех категорий
    func fetchAllCategories() -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        do {
            let categoryEntities = try context.fetch(fetchRequest)
            return categoryEntities.map { TrackerCategory(title: $0.title ?? "", trackers: []) }
        } catch {
            print("Ошибка при загрузке категорий: \(error)")
            return []
        }
    }

    // Удаление категории
    func deleteCategory(_ category: TrackerCategory) {
        let fetchRequest: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", category.title)
        do {
            if let categoryEntity = try context.fetch(fetchRequest).first {
                context.delete(categoryEntity)
                try context.save()
            }
        } catch {
            print("Ошибка при удалении категории: \(error)")
        }
    }
}
