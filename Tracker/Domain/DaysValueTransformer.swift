//
//  DaysValueTransformer.swift
//  Tracker
//
//  Created by Никита Гончаров on 26.01.2024.
//

import UIKit

@objc(DaysValueTransformer)
final class DaysValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [WeekDay] else { return nil }
        
        do {
            let encode = try JSONEncoder().encode(days)
            return encode
        } catch {
            assertionFailure("Failed to transform `WeekDay` to `JSON`")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        
        do {
            let decode = try JSONDecoder().decode([WeekDay].self, from: data as Data)
            return decode
        } catch {
            assertionFailure("Failed to transform `JSON` to `WeekDay`")
            return nil
        }
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            DaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        )
    }
}
