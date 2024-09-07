//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Sergey Ivanov on 06.09.2024.
//

import UIKit

class TrackersViewController: UIViewController {
    // Список категорий и трекеров
    var categories: [TrackerCategory] = []
    
    // Трекеры, которые были выполнены
    var completedTrackers: [TrackerRecord] = []

    // Метод для добавления трекера в категорию
    func addTracker(_ tracker: Tracker, to categoryTitle: String) {
        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
            // Создаем новую категорию с обновленным списком трекеров
            var updatedCategory = categories[index]
            updatedCategory = TrackerCategory(title: updatedCategory.title, trackers: updatedCategory.trackers + [tracker])
            // Создаем новый массив категорий и обновляем его
            var newCategories = categories
            newCategories[index] = updatedCategory
            categories = newCategories
        } else {
            // Если категория не существует, создаем новую категорию и добавляем туда трекер
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categories.append(newCategory)
        }
    }
    
    // Метод для отметки трекера как выполненного
    func completeTracker(_ trackerID: UUID, on date: Date) {
        let record = TrackerRecord(trackerID: trackerID, date: date)
        completedTrackers.append(record)
    }

    // Метод для отмены выполнения трекера
    func undoCompleteTracker(_ trackerID: UUID, on date: Date) {
        completedTrackers.removeAll { $0.trackerID == trackerID && $0.date == date }
    }
}
