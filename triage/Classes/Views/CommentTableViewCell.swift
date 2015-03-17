//
//  CommentTableViewCell.swift
//  triage
//
//  Created by Yeu-Shuan Tang on 3/16/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    var ticket: Ticket?{
        didSet {
            if let t = ticket {
                createAtLabel.text = t.createdAtInWords()
                commentLabel.text = t.description
                if let r = t.requester? {
                    userNameLabel.text = r.fields.name
                } else {
                    userNameLabel.text = ""
                }
            } else {
                createAtLabel.text = "no ticket"
            }
        }
    }

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userPhotoView: UIImageView!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var createAtLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
