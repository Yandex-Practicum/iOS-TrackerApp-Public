//
//  UIColorTransformer.swift
//  Tracker
//
//  Created by Sergey Ivanov on 09.10.2024.
//

import UIKit
import CoreData

@objc(UIColorTransformer)
final class UIColorTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
            return data
        } catch {
            print("Ошибка при архивации UIColor: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
            return color
        } catch {
            print("Ошибка при распаковке UIColor: \(error)")
            return nil
        }
    }
}
