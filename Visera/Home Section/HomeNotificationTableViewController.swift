//
//  HomeNotificationTableViewController.swift
//  Visera
//
//  Created by student-2 on 20/12/24.
//
// HomeNotificationTableViewController.swift
import UIKit

class HomeNotificationTableViewController: UITableViewController {
    
    var notifications: [HomeNotification] = [
        HomeNotification(homeNotificationName: "A user liked your post"),
        HomeNotification(homeNotificationName: "You got a new follower"),
        HomeNotification(homeNotificationName: "Someone commented on your event"),
        HomeNotification(homeNotificationName: "A new event has been created")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the notification cell if you're using a custom cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationCell")
    }
    
    // MARK: - UITableViewDataSource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Only one section for notifications
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count // Number of notifications
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        
        // Configure the cell with the notification data
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.homeNotificationName
        
        return cell
    }
    
    // MARK: - HomePostFeedCollectionViewCellDelegate
    func crownButtonTappedForNotification(message: String) {

        
        let newNotification = HomeNotification(homeNotificationName: message)
        notifications.insert(newNotification, at: 0)  // Insert at the top
        tableView.reloadData()  // Reload the table view to show the new notification
    }
    
    // Implement other table view methods...
}
