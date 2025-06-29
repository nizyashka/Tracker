//
//  ScheduleValueTransformer.swift
//  Tracker
//
//  Created by Алексей Непряхин on 19.06.2025.
//

import UIKit

@objc
final class ScheduleValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let schedule = value as? [String] else { return nil }
        return try? JSONEncoder().encode(schedule)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([String].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            ScheduleValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: ScheduleValueTransformer.self)))
    }
}
