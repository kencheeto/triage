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

    var ticket: Ticket! {
      didSet {
        detailTableView.reloadData()
        loadComments()
      }
    }
  
    var comments: [Comment]? {
      didSet {
        self.comments = self.comments?.reverse()
        detailTableView.reloadData()
      }
    }
  
    @IBOutlet var headerView: UIView!
    @IBOutlet var detailTableView: UITableView!
    @IBOutlet var cancelButton: UIButton!
    
    var delegate: TicketsViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
        detailTableView.estimatedRowHeight = 44
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.layoutMargins = UIEdgeInsetsZero
        detailTableView.separatorColor = UIColor.whiteColor()
        detailTableView.separatorInset = UIEdgeInsetsZero
        detailTableView.tableFooterView = UIView()
        detailTableView.allowsSelection = false
       
        cancelButton.setTitleColor(Colors.Forest, forState: .Normal)
        cancelButton.setTitle("×", forState: .allZeros)
        cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        
        headerView.backgroundColor = Colors.Snow
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onCancelButton(sender: UIButton) {
        delegate?.onCancelbutton(self)
    }
  
    func loadComments() {
      ZendeskAPI.instance.getTicketComments(ticket.id, success: didLoadComments, failure: apiFailure)
    }
  
    func didLoadComments(operation: AFHTTPRequestOperation!, comments: [Comment]) {
      self.comments = comments
      detailTableView.reloadData()
    }
  
  func apiFailure(operation: AFHTTPRequestOperation!, error: NSError) {
      println(error.localizedDescription)
    }
  
}

extension DetailTableViewCell:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailSubjectTableViewCell") as DetailSubjectTableViewCell
            cell.ticket = ticket
            cell.layoutMargins = UIEdgeInsetsZero
            cell.updateConstraintsIfNeeded()
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell") as CommentTableViewCell
            cell.ticket = ticket
            if comments != nil {
              cell.comment = comments![indexPath.row - 1]
            }
            cell.layoutMargins = UIEdgeInsetsZero
            cell.updateConstraintsIfNeeded()
//            cell.contentView.backgroundColor = Colors.Snow
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let c = self.comments {
          return c.count + 1
        } else {
          return 2
        }
      }
}

