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
        
        let urlString = "https://www.guidebook.com/service/v2/upcomingGuides/"
        let url = URL(string: urlString)
        fetchGuidebookData(with: url!)
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
    func fetchGuidebookData(with url: URL) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("JSON Error: \(error)")
                return
            }
            if let jsonData = data {
                print("JSON Data got.")
                let resultArray: ResultArray = try! JSONDecoder().decode(ResultArray.self, from: jsonData)
                self!.ungroupedGuides = resultArray.guides
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.tableView.rowHeight = UITableView.automaticDimension
                    self?.tableView.estimatedRowHeight = (self?.tableView.rowHeight)!
                }
            }
        }
        task.resume()
    }
    
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


