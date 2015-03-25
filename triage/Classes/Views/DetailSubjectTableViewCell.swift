//
//  DetailSubjectTableViewCell.swift
//  triage
//
//  Created by Yeu-Shuan Tang on 3/16/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

class DetailSubjectTableViewCell: UITableViewCell {
    
    var ticket: Ticket?{
        didSet {
            if let t = ticket {
                subjectLabel.text = t.subject
                dateLabel.text = t.createAtInEnglish()
                if let r = t.requester? {
                    userNameLabel.text = r.fields.name
                } else {
                    userNameLabel.text = ""
                }
            } else {
                subjectLabel.text = "no ticket"
                dateLabel.text = "no ticket"
            }
        }
    }

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var subjectLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subjectLabel.font = UIFont(name: "ProximaNova-Sbold", size: 18.0)
        dateLabel.font = UIFont(name: "ProximaNova-Regular", size: 12.0)
        userNameLabel.font = UIFont(name: "ProximaNova-Regular", size: 13.0)

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
