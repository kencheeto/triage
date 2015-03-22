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
  
  var comment: Comment? {
    didSet {
      updateFromComment()
    }
  }
  
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userPhotoView: UIImageView!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var createAtLabel: UILabel!
    override func awakeFromNib() {
      super.awakeFromNib()
      userPhotoView.layer.cornerRadius = userPhotoView.bounds.width / 2
      userPhotoView.layer.borderColor = UIColor.whiteColor().CGColor
      userPhotoView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func updateFromComment() {
      if let c = comment {
        if let u = c.author {
          self.userNameLabel.text = u.fields.name
          self.userPhotoView.setImageWithURL(NSURL(string: u.avatarURL()))
        }
        commentLabel.text = c.fields.body
        createAtLabel.text = c.createdAgoInWords()
        
    }
  }
}
