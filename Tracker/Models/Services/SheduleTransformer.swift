//
//  SheduleTransformer.swift
//  Tracker
//
//  Created by Sergey Ivanov on 09.10.2024.
//

import CoreData
import UIKit

@objc(ScheduleTransformer)
final class ScheduleTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let schedule = value as? [String] else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: schedule, requiringSecureCoding: true)
            return data
        } catch {
            print("Ошибка при архивации расписания: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let schedule = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self], from: data) as? [String]
            return schedule
        } catch {
            print("Ошибка при распаковке расписания: \(error)")
            return nil
        }
    }
}
