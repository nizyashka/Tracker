//
//  DateFormatter+Extensions.swift
//  Tracker
//
//  Created by Алексей Непряхин on 15.06.2025.
//

import Foundation

extension DateFormatter {
    static let trackerDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
}
