//
//  GuidebookTableViewController.swift
//  GuidebookChallenge
//
//  Created by Mengyuan Tian on 2021/6/22.
//

import UIKit

typealias GuidebookTVCViewModelDidUpdate = () -> Void

class GuidebookTableViewController: UITableViewController {
    
    var viewModel: GuidebookTVCViewModel!
    
    // MARK: - Viewcontroller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        
        let ns = NetworkService()
        let vm = GuidebookTVCViewModel(ns: ns) {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
        self.viewModel = vm
        viewModel.fetchGuides()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.datesString.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = viewModel.datesString[section]
        return viewModel.guidesDict[key]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuidebookItem", for: indexPath)
        if let guidebookCell = cell as? GuidebookTableViewCell {
            let key = viewModel.datesString[indexPath.section]
            guidebookCell.guide = viewModel.guidesDict[key]![indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { 
        return viewModel.datesString[section]
    }
    
    // MARK: - Other functions
    
    private func updateUI() {
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
    }
    
}



