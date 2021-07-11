//
//  GuidebookTVCViewModel.swift
//  GuidebookChallenge
//
//  Created by Mengyuan Tian on 2021/7/4.
//

import Foundation

class GuidebookTVCViewModel {
    
    init(ns: NetworkServiceProvider, didUpdate: @escaping GuidebookTVCViewModelDidUpdate) {
        self.networkService = ns
        self.didUpdateClosure = didUpdate
    }
    
    var guidesDict = [String: [Guide]]()
    var datesString = [String]()
    
    var networkService: NetworkServiceProvider!
    var didUpdateClosure: GuidebookTVCViewModelDidUpdate
    
    func fetchGuides() {
        networkService.fetchGuides() { result in
            switch result {
            case .failure:
                break
            case .success(let guides):
                self.setGuidesDictAndDatesString(guides: guides)
            }
        }
    }
    
    private func setGuidesDictAndDatesString(guides: [Guide]) {
        for guide in guides {
            if datesString.contains(guide.startDate) {
                guidesDict[guide.startDate]!.append(guide)
            } else {
                datesString.append(guide.startDate)
                guidesDict[guide.startDate] = [guide]
            }
        }
        
        datesString.sort() {
            formatDate(fromStr: $0) > formatDate(fromStr: $1)
        }
        
        didUpdateClosure()
    }

    private func formatDate(fromStr str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM d, yyyy"
        if let date = dateFormatter.date(from: str) {
            return date
        }
        return Date()
    }
    
//    func formatDateString(fromDate date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "MMM d, yyyy"
//        let dateStr = dateFormatter.string(from: date)
//        return dateStr
//    }
    
}
