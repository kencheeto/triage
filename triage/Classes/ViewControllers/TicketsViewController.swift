//
//  TicketsViewController.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

let kViewID = 47205968
let kAssignToTier1MacroID = 47314978
let kAssignToTrashAgent = 47314477

class TicketsViewController: UIViewController {

  private let notificationCenter: NSNotificationCenter =
    NSNotificationCenter.defaultCenter()

  private let API = ZendeskAPI.instance

  private var page: Int = 1

  // XXX - Change to enum for state
  private var isExhausted: Bool = false
  private var isFetching: Bool = false
  private var isRefreshing: Bool = false

  private let emptyDataSource =  EmptyTableViewSource()
  private let loadingDataSource = LoadingTableViewSource()
  private let initialTableViewRowHeight = CGFloat(115)
  private var flag = false
  private var selectedRowIndex: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
  private var offset: CGFloat!
  private var collapsed: Bool = false
  var macros: [Macro] = []
  var rows: [TicketFilterRow] = []

  private var parameters: NSMutableDictionary {
    get {
      return [
        "per_page": 30,
        "page": self.page + 1,
        "sort_order": "desc",
        "group_by": "+",
        "include": "via_id"
      ]
    }
  }

  @IBOutlet weak var ticketsTableView: UITableView!

  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  lazy private var activityIndicator: UIActivityIndicatorView =
    UIActivityIndicatorView(activityIndicatorStyle: .Gray)
  lazy private var refreshControl: UIRefreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    becomeFirstResponder()

    ticketsTableView.rowHeight = initialTableViewRowHeight
    ticketsTableView.estimatedRowHeight = initialTableViewRowHeight//44
    ticketsTableView.delegate = self
    ticketsTableView.dataSource = loadingDataSource
    ticketsTableView.layoutMargins = UIEdgeInsetsZero
    ticketsTableView.separatorInset = UIEdgeInsetsZero

    activityIndicator.frame = CGRectMake(
      0,
      0,
      ticketsTableView.bounds.width,
      44
    )
    ticketsTableView.tableFooterView = activityIndicator
    ticketsTableView.insertSubview(refreshControl, atIndex: 0)

    refreshControl.addTarget(
      self,
      action: "willRefresh:",
      forControlEvents: .ValueChanged
    )
    
    configureNavBar()
    self.setScrollingNavbarDelegate(self)

    activityIndicator.startAnimating()

    fetchMacros()
    fetchTicketRows(page: 1)
  }
  
  override func canBecomeFirstResponder() -> Bool {
    return true
  }
  
  
  override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
    if motion == UIEventSubtype.MotionShake {
      simulateNoTickets()
    }
  }
  
  func simulateNoTickets() {
    rows.removeAll(keepCapacity: true)
    isExhausted = true
    configureTableView()
  }
  
  func configureNavBar() {
    let button = TriageButton(height: 24.0, fontSize: 14.0)
    button.frame = CGRectMake(0, 0, 75, 24)
    button.setTitle("Sign out", forState: .allZeros)
    button.addTarget(self, action: "doLogout", forControlEvents: UIControlEvents.TouchDown)
    let logoutButton = UIBarButtonItem(customView: button)
    self.navigationItem.leftBarButtonItem = logoutButton

    let logoView = UIImageView(
      image: UIImage(named: "LogoSansText")
    )
    logoView.contentMode = .ScaleAspectFit
    logoView.frame = CGRectMake(0, 0, 25, 25)
    self.navigationItem.titleView = logoView

    self.followScrollView(ticketsTableView, usingTopConstraint: topConstraint, withDelay: 65)
    self.setShouldScrollWhenContentFits(true)

    navigationController?.navigationBar.translucent = false
    navigationController?.navigationBar.tintColor = Colors.ZendeskGreen
  }
    
  func doLogout() {
    notificationCenter.postNotificationName(LogoutNotification, object: self)
  }
  
  func configureTableView() {
    if rows.count > 0 {
      ticketsTableView.dataSource = self
      ticketsTableView.rowHeight = UITableViewAutomaticDimension
    } else if isFetching || isRefreshing {
      ticketsTableView.rowHeight = initialTableViewRowHeight
      ticketsTableView.dataSource = loadingDataSource
    } else {
      ticketsTableView.rowHeight = initialTableViewRowHeight
      ticketsTableView.dataSource = emptyDataSource
    }
    
    ticketsTableView.reloadData()
  }

  func fetchMacros() {
    API.getMacros(success: didFetchMacros, failure: nil)
  }

  func fetchTicketRows(#page: Int?) {
    if (isFetching) {
      return
    }

    var params: NSMutableDictionary = parameters

    isFetching = true

    if page != nil {
      params["page"] = page!
    } else {
      self.page = params["page"] as Int
    }

    API.executeView(
      kViewID,
      parameters: params,
      success: didFetchTicketRows,
      failure: didError
    )
  }

  func removeAtIndex(index: NSIndexPath) {
    rows.removeAtIndex(index.row)
  }

  func didFetchMacros(operation: AFHTTPRequestOperation!, macros: [Macro]) {
    self.macros = macros
  }

  func didFetchTicketRows(operation: AFHTTPRequestOperation!, rows: [TicketFilterRow]) {

    isExhausted = rows.count == 0
    
    if (isRefreshing) {
      self.rows = rows
    } else {
      self.rows += rows
    }
    
    isFetching = false
    isRefreshing = false
    
    configureTableView()
    
    activityIndicator.stopAnimating()
    refreshControl.endRefreshing()
  }
  


  func didError(operation: AFHTTPRequestOperation!, error: NSError) {
    activityIndicator.stopAnimating()
    refreshControl.endRefreshing()
    isFetching = false
    isRefreshing = false
  }

  func willRefresh(sender: UIRefreshControl) {
    sender.beginRefreshing()
    isRefreshing = true
    configureTableView()
    fetchTicketRows(page: 1)
  }
  
  func loadMoreTicketsIfNeeded() {
    if isFetching || isExhausted {
      return
    }
    
    let tableHeight = ticketsTableView.frame.height
    let offset = ticketsTableView.contentOffset.y + tableHeight
    let limit = ticketsTableView.contentSize.height - 300
  
    if (offset > limit) {
      println("running low of tickets - loading more")
      fetchTicketRows(page: nil)
    }
  }

  func scrollViewDidScroll(scrollView: UIScrollView) {
    loadMoreTicketsIfNeeded()
  }

  /*
   * Straight copy from TicketTableViewCell.
   *
   * For the unlazy, feel free to refactor.
   */
  override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer){
      let panGestureRecognizer = gestureRecognizer as UIPanGestureRecognizer
      let translation = panGestureRecognizer.translationInView(
        panGestureRecognizer.view!
      )

      return fabs(translation.x) < fabs(translation.y)
    } else {
      return true
    }
  }
}

extension TicketsViewController: UITableViewDelegate {

  
  
}

extension TicketsViewController: UITableViewDataSource{
    
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let row = rows[indexPath.row]
    
    if (indexPath.row == self.selectedRowIndex.row){
        let cell = ticketsTableView.dequeueReusableCellWithIdentifier(
            "DetailTableViewCell", forIndexPath: indexPath
            ) as DetailTableViewCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.ticket = row.ticket
        cell.comments = nil
        cell.delegate = self
        cell.detailTableView.reloadData()
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    let cell = ticketsTableView.dequeueReusableCellWithIdentifier(
      "TicketTableViewCell", forIndexPath: indexPath
    ) as TicketTableViewCell

    cell.layoutMargins = UIEdgeInsetsZero
    cell.ticket = row.ticket
    cell.delegate = self
    cell.updateConstraintsIfNeeded()

    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }
    
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var animatedNav = !collapsed
    self.stopFollowingScrollView()
    tableView.scrollEnabled = false
    tableView.allowsSelection = false
    selectedRowIndex = indexPath
    
    offset = tableView.contentOffset.y
    var cellRect = tableView.rectForRowAtIndexPath(indexPath)
    println("\(cellRect.minY)")
    
    println("new\(ticketsTableView.contentOffset.y)")
    tableView.beginUpdates()
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    tableView.endUpdates()
    
    if animatedNav{
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        tableView.contentOffset = CGPoint(x: 0, y: cellRect.minY + 20)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
      })
    } else {
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        tableView.contentOffset = CGPoint(x: 0, y: cellRect.minY)
      })
    }
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == selectedRowIndex.row {
        return self.view.bounds.height + 64
    }else {
      return initialTableViewRowHeight
    }
  }
}

extension TicketsViewController: TicketTableViewCellDelegate, DetailTableViewCellDelegate {
  
  func didFarRightSwipe(cell: TicketTableViewCell) {
    println("didFarRightSwipe")
    let viewController =
      storyboard?.instantiateViewControllerWithIdentifier("MacrosViewController") as MacrosViewController

    viewController.transitioningDelegate = viewController
    viewController.macros = macros
    viewController.modalPresentationStyle = .Custom
    viewController.cell = cell

    UIView.animateWithDuration(0.2, animations: {
      cell.center.x = cell.bounds.width / 2
    })

    viewController.ticketsViewController = self
    presentViewController(viewController, animated: true, completion: nil)
  }

  func didNearRightSwipe(cell: TicketTableViewCell) {
    let indexPath = ticketsTableView.indexPathForCell(cell)!
    
    loadMoreTicketsIfNeeded() // this needs to be before we remove the cell since the contentsize.height is wrong afterwards
    rows.removeAtIndex(indexPath.row)
    ticketsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
    
    API.applyMacroToTicket(
      kAssignToTier1MacroID,
      ticketID: cell.ticket!.id,
      success: { (operation: AFHTTPRequestOperation!, result: MacroResult) -> Void in
        let ticket = result.ticket

        cell.ticket = ticket

        ticket.save(success: nil, failure: nil)
      },
      failure: nil
    )
    println("didNearRightSwipe")
  }

  func didLeftSwipe(cell: TicketTableViewCell) {
    let indexPath = ticketsTableView.indexPathForCell(cell)!

    loadMoreTicketsIfNeeded() // this needs to be before we remove the cell since the contentsize.height is wrong afterwards
    rows.removeAtIndex(indexPath.row)
    ticketsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
    
    API.applyMacroToTicket(
      kAssignToTrashAgent,
      ticketID: cell.ticket!.id,
      success: { (operation: AFHTTPRequestOperation!, result: MacroResult) -> Void in
        let ticket = result.ticket

        cell.ticket = ticket

        ticket.save(success: nil, failure: nil)
      },
      failure: nil
    )
    println("didLeftSwipe")
  }
    
  func onCancelbutton(cell: DetailTableViewCell) {
    print("onCancelButton")
    self.selectedRowIndex = NSIndexPath(forRow: -1, inSection: 0)
    let indexPath = ticketsTableView.indexPathForCell(cell)!

    UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.ticketsTableView.contentOffset = CGPoint(x: 0, y: self.offset - 20)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    })
 
    self.ticketsTableView.beginUpdates()
    self.ticketsTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    self.ticketsTableView.endUpdates()
    self.ticketsTableView.scrollEnabled = true
    self.ticketsTableView.allowsSelection = true
    self.followScrollView(ticketsTableView, usingTopConstraint: topConstraint, withDelay: 65)
  }
}

extension TicketsViewController: AMScrollingNavbarDelegate {
    
    func navigationBarDidChangeToCollapsed(collapsed: Bool) {
        self.collapsed = true
    }
    
    func navigationBarDidChangeToExpanded(expanded: Bool) {
        self.collapsed = false
    }
}
