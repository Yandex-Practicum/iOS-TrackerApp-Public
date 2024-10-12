import CoreData

final class TrackerCategoryStore {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Добавление новой категории
    func addCategory(title: String) -> TrackerCategory? {
        let existingCategories = fetchAllCategories().filter { $0.title == title }
        
        // Проверяем, есть ли уже категория с таким названием
        if !existingCategories.isEmpty {
            print("Категория с таким названием уже существует")
            return existingCategories.first
        }

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
            let uniqueCategories = Array(Set(categoryEntities.map { TrackerCategory(title: $0.title ?? "", trackers: []) }))
            return uniqueCategories
        } catch {
            print("Ошибка при загрузке категорий: \(error)")
            return []
        }
    }

    // Редактирование категории
    func updateCategory(_ category: TrackerCategory, with newTitle: String) {
        let fetchRequest: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", category.title)

        do {
            if let categoryEntity = try context.fetch(fetchRequest).first {
                categoryEntity.title = newTitle
                try context.save()
            }
        } catch {
            print("Ошибка при обновлении категории: \(error)")
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
