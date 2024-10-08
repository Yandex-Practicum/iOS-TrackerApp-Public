//
//  TrackerStore.swift
//  Tracker
//
//  Created by Sergey Ivanov on 08.10.2024.
//

import CoreData
import UIKit

final class TrackerStore {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Добавление нового трекера
    func addTracker(name: String, color: UIColor, emoji: String, schedule: [String], category: TrackerCategory) -> Tracker? {
        let trackerEntity = TrackerEntity(context: context)
        trackerEntity.id = UUID()
        trackerEntity.name = name
        trackerEntity.color = color.toData()
        trackerEntity.emoji = emoji
        trackerEntity.schedule = schedule as NSObject

        // Здесь мы не используем напрямую `TrackerCategoryEntity`
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

    // Получение всех трекеров
    func fetchAllTrackers() -> [Tracker] {
        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        do {
            let trackerEntities = try context.fetch(fetchRequest)
            return trackerEntities.compactMap { tracker(from: $0) }
        } catch {
            print("Ошибка при загрузке трекеров: \(error)")
            return []
        }
    }

    // Преобразование TrackerEntity в Tracker
    private func tracker(from entity: TrackerEntity) -> Tracker? {
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
