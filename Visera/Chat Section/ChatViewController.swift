//
//  ChatViewController.swift
//  ChatApplication
//
//  Created by student-2 on 24/12/24.
//
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ChatRequestDetailDelegate,ChattingGeneralAndBusinessViewControllerDelegate {
   
    
    
    

    @IBOutlet weak var chatSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!  // Ensure this is connected to the storyboard

    
    @IBOutlet weak var messageLabelModel: UILabel!
    
    
    var generalChats: [ChatRequest] = []
    var businessChats: [ChatRequest] = []
    var currentChats: [ChatRequest] = []
    var filteredChats: [ChatRequest] = []  // Store filtered results for search

    override func viewDidLoad() {
        super.viewDidLoad()

        // Safely check if searchBar is connected and set delegate
        if let searchBar = searchBar {
            searchBar.delegate = self
            searchBar.placeholder = "Search by title"
        } else {
            print("Error: searchBar is nil")
        }

        // Safely check if tableView is connected
        if let tableView = tableView {
            tableView.dataSource = self
            tableView.delegate = self
        } else {
            print("Error: tableView is nil")
        }

        // Safely check if chatSegmentedControl is connected
        if let chatSegmentedControl = chatSegmentedControl {
            chatSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        } else {
            print("Error: chatSegmentedControl is nil")
        }

        // Initialize sample data
        initializeSampleData()
        updateChatList()
    }

    func initializeSampleData() {
        generalChats = [
            // Sample data (you can replace this with actual data)
//            ChatRequest(image: UIImage(named: "Agency1"), name: "Shina Sharma", message: "Hello, I have a general inquiry.", time: "12:30 PM", category: .general),
//            ChatRequest(image: UIImage(named: "Agency1"), name: "ABC Agency", message: "I need help with something.", time: "1:00 PM", category: .general)
        ]
        
        businessChats = [
//            // Sample data (you can replace this with actual data)
//            ChatRequest(image: UIImage(named: "Agency1"), name: "Shina Sharma", message: "I need assistance with a business matter.", time: "2:15 PM", category: .business),
//            ChatRequest(image: UIImage(named: "Agency1"), name: "ABC Agency", message: "Let's discuss a business proposal.", time: "3:30 PM", category: .business)
        ]
    }

    func updateChatList() {
        // Safely unwrap the selectedSegmentIndex to ensure it's not nil
        if let segmentIndex = chatSegmentedControl?.selectedSegmentIndex {
            switch segmentIndex {
            case 0:
                currentChats = generalChats
            case 1:
                currentChats = businessChats
            default:
                currentChats = []
            }
        } else {
            print("Error: chatSegmentedControl is nil while updating the chat list")
        }

        // Update the filtered chats
        filterChats()

        // Safely reload the table view if it's not nil
        if let tableView = tableView {
            tableView.reloadData()
        } else {
            print("Error: tableView is nil while reloading data")
        }
    }

    func filterChats() {
        if let searchText = searchBar?.text, !searchText.isEmpty {
            filteredChats = currentChats.filter { chat in
                return chat.name.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredChats = currentChats  // Show all chats if there's no search text
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRequestBusinessOrGeneral", for: indexPath) as? ChatBusinessOrGeneralTableViewCell {
            let chatRequest = filteredChats[indexPath.row]
            cell.configure(with: chatRequest)
            return cell
        } else {
            return UITableViewCell() // Return a default cell in case of error
        }
    }

    @objc func segmentChanged() {
        updateChatList()
    }

    func didCategorizeRequest(_ request: ChatRequest) {
        if request.category == .general {
            if let index = businessChats.firstIndex(where: { $0.name == request.name }) {
                businessChats.remove(at: index)
            }
            generalChats.insert(request, at: 0)
        } else if request.category == .business {
            if let index = generalChats.firstIndex(where: { $0.name == request.name }) {
                generalChats.remove(at: index)
            }
            businessChats.append(request)
        }

        updateChatList()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterChats()
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterChats()
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChatRequests" {
            if let destination = segue.destination as? ChatRequestTableViewController {
                destination.chatViewController = self
            }
        } else if segue.identifier == "showChatDetail", let indexPath = tableView.indexPathForSelectedRow {
            let chatRequest = filteredChats[indexPath.row]
            if let chattingVC = segue.destination as? ChattingGeneralAndBusinessViewController {
                chattingVC.chatName = chatRequest.name
                chattingVC.chatImage = chatRequest.image
                chattingVC.delegate = self
                chattingVC.messages = [(chatRequest.message, false)]
                chattingVC.chatTime = chatRequest.time
            }
        }
    }


//    func updateLastMessage(newMessage: String) {
//        // Assuming you have a reference to the correct chat (filteredChats[indexPath.row] or others)
//       
//        if let selectedIndexPath = tableView.indexPathForSelectedRow {
//            var selectedChatRequest = filteredChats[selectedIndexPath.row]
//            
//            // Update the message of the selected chat
//            selectedChatRequest.message = newMessage
//            
//            // Save the updated chat back to the array
//            filteredChats[selectedIndexPath.row] = selectedChatRequest
//            
//            // Print the last message to the console
//            print("*********************************Last message: \(newMessage)")
//            
//            // Reload the row to reflect the changes
//            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
//        }
//    }
    func updateLastMessage(newMessage: String) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            var selectedChatRequest = filteredChats[selectedIndexPath.row]

            // Update the message of the selected chat
            selectedChatRequest.message = newMessage

            // Save the updated chat back to the array
            filteredChats[selectedIndexPath.row] = selectedChatRequest

            // Print the last message to the console
            print("*********************************Last message: \(newMessage)")

            // Update the cell directly without reloading the row
            if let cell = tableView.cellForRow(at: selectedIndexPath) as? ChatBusinessOrGeneralTableViewCell {
                cell.chatBusinessOrGeneralMessage.text = newMessage
            }
        }
    }


    


    func updateChatTime(newTime: String) {
        // Assuming you have a reference to the correct chat (filteredChats[indexPath.row] or others)
        print(tableView.indexPathForSelectedRow)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            var selectedChatRequest = filteredChats[selectedIndexPath.row]
            
            // Update the time for the selected chat
            selectedChatRequest.time = newTime
            
            // Update the chat in the array
            filteredChats[selectedIndexPath.row] = selectedChatRequest
            // Reload the row to reflect changes
//            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            if let cell = tableView.cellForRow(at: selectedIndexPath) as? ChatBusinessOrGeneralTableViewCell {
                cell.chatBusinessOrGeneralTime.text = newTime
            }
        }
    }


}
