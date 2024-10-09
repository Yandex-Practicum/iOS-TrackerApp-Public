//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Sergey Ivanov on 08.10.2024.
//

import CoreData

final class TrackerRecordStore {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Добавление записи о выполнении трекера
    func addRecord(for tracker: Tracker, date: Date) -> TrackerRecord? {
        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            if let trackerEntity = try context.fetch(fetchRequest).first {
                let recordEntity = TrackerRecordEntity(context: context)
                recordEntity.tracker = trackerEntity
                recordEntity.date = date

                try context.save()
                print("В Cored Data была выполнена запись о выполнении: \(TrackerRecord(trackerID: tracker.id, date: date))")
                return TrackerRecord(trackerID: tracker.id, date: date)
            }
        } catch {
            print("Ошибка при создании записи о выполнении: \(error)")
        }
        return nil
    }

    // Получение всех записей
    func fetchAllRecords() -> [TrackerRecord] {
        let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        do {
            let recordEntities = try context.fetch(fetchRequest)
            print("Записи на дату : \(recordEntities.map { "\($0)" })")
            return recordEntities.compactMap { record(from: $0) }
        } catch {
            print("Ошибка при загрузке записей: \(error)")
            return []
        }
    }
    
    // Получение записей о выполнении трекеров на определенную дату
    func fetchRecords(for date: Date) -> [TrackerRecord] {
        let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        
        // Используем NSPredicate для фильтрации по дате без учета времени
        let startOfDay = Calendar.current.startOfDay(for: date)
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, nextDay as NSDate)
        
        do {
            let recordEntities = try context.fetch(fetchRequest)
            print("Записи на дату \(date): \(recordEntities.map { "\($0.date ?? Date())" })")
            return recordEntities.compactMap { record(from: $0) }
        } catch {
            print("Ошибка при загрузке записей: \(error)")
            return []
        }
    }

    // Преобразование TrackerRecordEntity в TrackerRecord
    private func record(from entity: TrackerRecordEntity) -> TrackerRecord? {
        guard let id = entity.tracker?.id,
              let date = entity.date else {
            return nil
        }
        return TrackerRecord(trackerID: id, date: date)
    }
}
