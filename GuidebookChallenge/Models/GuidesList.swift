//
//  GuidesList.swift
//  GuidebookChallenge
//
//  Created by Mengyuan Tian on 2021/6/23.
//

import Foundation

struct GuidesList {
    var startDateString: String {
        didSet {
            let dateString = startDateString
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "MMM d, yyyy"
            if let date = dateFormatter.date(from: dateString) {
                self.startDate = date
            }
        }
    }
    var startDate: Date
    var guides: [Guide]
}
