//
//  GuidebookTableViewCell.swift
//  GuidebookChallenge
//
//  Created by Mengyuan Tian on 2021/6/22.
//

import UIKit

class GuidebookTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    
    // MARK: - Service
    var guide: Guide? {
        didSet {
            if let guide = guide {
                updateUI(withGuide: guide)
            }
        }
    }

    fileprivate func updateUI(withGuide guide: Guide) {
        //reset any existing information
        nameLabel?.text = nil
        cityLabel?.text = nil
        stateLabel?.text = nil
        endDateLabel?.text = nil
        
        //load new info
        nameLabel.text = guide.name
        
        if let cityName = guide.venue?.city {
            cityLabel.text = cityName
        }
        if let stateName = guide.venue?.state {
            cityLabel.text = stateName
        }
        endDateLabel.text = "End date: " + guide.endDate
    }

}
