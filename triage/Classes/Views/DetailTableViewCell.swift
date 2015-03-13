//
//  DetailTableViewCell.swift
//  triage
//
//  Created by Yeu-Shuan Tang on 3/12/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit
protocol DetailTableViewCellDelegate {
    func onCancelbutton(cell: DetailTableViewCell)
}

class DetailTableViewCell: UITableViewCell{

    var ticket: Ticket?{
        didSet {
            if let t = ticket {
                subjectLabel.text = t.subject
//                descriptionLabel.text = t.description
                createdAtLabel.text = t.createAtInEnglish()
                
                if let r = t.requester? {
                    requesterLabel.text = r.fields.name
//                    userAvatar.setImageWithURL(NSURL(string: r.avatarURL()))
                } else {
                    requesterLabel.text = ""
                }
                
            } else {
                subjectLabel.text = "no ticket"
//                descriptionLabel.text = "no ticket"
                createdAtLabel.text = "no ticket"
            }
        }

    }

    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var requesterLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var subjectLabel: UILabel!
    
    var delegate: TicketsViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onCancelButton(sender: UIButton) {
        delegate?.onCancelbutton(self)
    }
    
}
