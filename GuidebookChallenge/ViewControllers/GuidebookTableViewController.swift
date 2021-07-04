//
//  GuidebookTableViewController.swift
//  GuidebookChallenge
//
//  Created by Mengyuan Tian on 2021/6/22.
//

import UIKit

class GuidebookTableViewController: UITableViewController {
    var guidesDict = [Date: [Guide]]()
    var dates = [Date]()
    var ungroupedGuides = [Guide]() {
        didSet {
            self.mapGuides()
        }
    }
    
    // MARK: - Constants
    fileprivate struct Storyboard {
        static let guideCellIdentifier = "GuidebookItem"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        
        let networkService = NetworkService()
        networkService.fetchGuides() { result in
            switch result {
            case .failure( let error):
                print(error)
            case .success(let guides):
                self.ungroupedGuides = guides
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.rowHeight = UITableView.automaticDimension
                    self.tableView.estimatedRowHeight = self.tableView.rowHeight
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = dates[section]
        return guidesDict[key]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.guideCellIdentifier, for: indexPath)
        if let guidebookCell = cell as? GuidebookTableViewCell {
            let key = dates[indexPath.section]
            guidebookCell.guide = guidesDict[key]![indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = dates[section]
        return formatDateString(fromDate: key)
    }

    // MARK: - Other functions
    
    func mapGuides() {
        for guide in ungroupedGuides {
            let date = formatDate(fromStr: guide.startDate)
            if dates.contains(date) {
                guidesDict[date]!.append(guide)
            } else {
                dates.append(date)
                guidesDict[date] = [guide]
            }
        }
        dates.sort() { $0 > $1 }
    }
    
    func formatDate(fromStr str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM d, yyyy"
        if let date = dateFormatter.date(from: str) {
            return date
        }
        return Date()
    }
    
    func formatDateString(fromDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}



