//
//  MessageViewController.swift
//  Visera
//
//  Created by student-2 on 23/12/24.
//
import UIKit
class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var messages: [ChatRequest]  // The array of messages to display

    // Inject the messages into the view controller when it's created
    init(messages: [ChatRequest]) {
        self.messages = messages
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the table view
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)

        // Set constraints for the table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        // Register a custom cell if needed (or use the default)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
        
        // Set the table view data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of messages in the array
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)

        // Get the message for the current index path
        let message = messages[indexPath.row]

        // Configure the cell to display the message's details
        cell.textLabel?.text = "\(message.name): \(message.message)"  // You can format this as you like
        cell.detailTextLabel?.text = message.time  // Add a time label if needed
        cell.imageView?.image = message.image  // Set the image if it's available

        // Customize the cell's appearance
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width ?? 0) / 2
        cell.imageView?.clipsToBounds = true
        cell.imageView?.tintColor = .black

        return cell
    }
    
    // MARK: - UITableViewDelegate Methods

    // If you want to handle row selection (e.g., when a message is tapped), you can implement this method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMessage = messages[indexPath.row]
        print("Selected message: \(selectedMessage.message) from \(selectedMessage.name)")
        
        // You can add navigation or perform actions based on the selected message
    }
}
