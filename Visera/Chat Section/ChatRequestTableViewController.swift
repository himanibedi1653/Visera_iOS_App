//
//  ChatRequestTableViewController.swift
//  ChatApplication
//
//  Created by student-2 on 24/12/24.
//
import UIKit

class ChatRequestTableViewController: UITableViewController {

    // Static variable to store chat requests
    static var chatRequests: [ChatRequest] = []
    var chatViewController: ChatViewController?

    static var loadingFirstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Debugging: Show count before loading the screen
        print("------------------------------Count before loading the screen \(ChatRequestTableViewController.chatRequests.count)")

        // Example dummy chat requests
        var dummyChatRequests = [
            ChatRequest(image: UIImage(named: "Agency1"), name: "Agency 1", message: "Good afternoon, we would like to discuss our latest business proposal with you.", time: "12:30 PM", category: .business),
            ChatRequest(image: UIImage(named: "Agency2"), name: "Agency 2", message: "I hope all is well. Let us know if you'd like to discuss the current market trends.", time: "1:00 PM", category: .general),
            ChatRequest(image: UIImage(named: "Agency3"), name: "Agency 3", message: "We have some important updates regarding the partnership agreement we discussed.", time: "2:15 PM", category: .business),
            ChatRequest(image: UIImage(named: "Agency4"), name: "Agency 4", message: "It was great speaking with you last time. Looking forward to hearing more from your side.", time: "12:30 PM", category: .business),
            ChatRequest(image: UIImage(named: "Agency5"), name: "Agency 5", message: "If there's anything we can assist with regarding the project, feel free to let us know.", time: "1:00 PM", category: .general),
            ChatRequest(image: UIImage(named: "Agency6"), name: "Agency 6", message: "We’re ready to proceed with our discussions whenever you’re available. Let’s plan a meeting soon.", time: "2:15 PM", category: .business)
        ]

        // Assign a unique UUID to each dummy chat request
        for (index, var chatRequest) in dummyChatRequests.enumerated() {
            chatRequest.id = UUID() // Assigning a unique ID
            dummyChatRequests[index] = chatRequest // Update the array element with new UUID
        }

        // Only load dummy data the first time
        if ChatRequestTableViewController.loadingFirstTime {
            ChatRequestTableViewController.chatRequests = dummyChatRequests
            print(ChatRequestTableViewController.loadingFirstTime)
            ChatRequestTableViewController.loadingFirstTime = false
        }

        // Debugging: Show count after loading the screen
        print("------------------------------Count After loading the screen \(ChatRequestTableViewController.chatRequests.count)")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Only one section for chat requests
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatRequestTableViewController.chatRequests.count // Return the number of chat requests
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRequestCell", for: indexPath) as? ChatRequestTableViewCell else {
            return UITableViewCell() // Default cell in case of error
        }

        // Get the chat request for the current row
        let chatRequest = ChatRequestTableViewController.chatRequests[indexPath.row]

        // Configure the cell with data
        cell.configure(with: chatRequest)

        return cell
    }

    // MARK: - Segue Preparation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChatRequestDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRequest = ChatRequestTableViewController.chatRequests[indexPath.row]
                if let detailVC = segue.destination as? ChatRequestDetailViewController {
                    detailVC.chatRequest = selectedRequest
                    detailVC.delegate = chatViewController
                }
            }
        }
    }
}

// MARK: - ChatRequestDetailDelegate

extension ChatRequestTableViewController: ChatRequestDetailDelegate {
    func didCategorizeRequest(_ request: ChatRequest) {
        // Debugging: Show chat requests before removal
        print("Before removal: \(ChatRequestTableViewController.chatRequests)")

        // Remove the categorized request based on its unique ID
        if let index = ChatRequestTableViewController.chatRequests.firstIndex(where: { $0.id == request.id }) {
            ChatRequestTableViewController.chatRequests.remove(at: index)
            print("Removed request: \(request)")
        }

        // Debugging: Show chat requests after removal
        print("After removal: \(ChatRequestTableViewController.chatRequests)")

        // Reload the table view to reflect the updated data
        tableView.reloadData()
    }
}
