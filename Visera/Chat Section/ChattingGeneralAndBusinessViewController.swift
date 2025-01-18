//
//  ChattingGeneralAndBusinessViewController.swift
//  ChatApplication
//
//  Created by student-2 on 10/01/25.
//
import UIKit
protocol ChattingGeneralAndBusinessViewControllerDelegate: AnyObject {
    func updateLastMessage(newMessage: String)
    func updateChatTime(newTime: String)
}

class ChattingGeneralAndBusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    weak var delegate: ChattingGeneralAndBusinessViewControllerDelegate?

    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!

    var imageModel: UIImageView!
    var nameModel: UILabel!
    var currentUserInputField: UITextView!
    var messagesTableView: UITableView!
    var sendButton: UIButton!

    var chatImage: UIImage?
    var chatName: String?
    var messages: [(String, Bool)] = []
    var predefinedResponses = [
        "Hi there! How can I assist you today?",
        "Sure, I can help with that.",
        "Let me check that for you.",
        "Can you provide more details?",
        "Thank you for your patience!"
    ]
    var chatTime: String?
    var responseIndex = 0
    var isNewSession = true  // Flag to prevent saving during new session

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Set image and name if available
        if let image = chatImage {
            personImage.image = image
        }
        if let name = chatName {
            personNameLabel.text = name
        }

        // Print the chat time to debug or display it in the UI
        if let time = chatTime {
//            print("Chat Time: \(time)") // Debugging print
            // Optionally, update a UILabel or another UI element with the time
            updateChatTimeLabel(with: time)
        }

        // Load saved messages from UserDefaults
        loadMessagesFromUserDefaults()

        // Set isNewSession to false after loading saved messages
        isNewSession = false

        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        
        // Setup the "Clear All Chats" button as a bar button item
        setupClearAllChatsButton()

        // If it's a new chat session, show the first message from the other user
//        if messages.isEmpty {
//            simulateFirstMessage()
//        }
        setupTimeLabel()
        scrollToLastMessage()
  
    }

    func scrollToLastMessage() {
        guard !messages.isEmpty else { return } // Ensure there are messages to scroll to
        guard messagesTableView.numberOfRows(inSection: 0) > 0 else { return } // Ensure rows are loaded

        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }



    func simulateFirstMessage() {
        guard responseIndex < predefinedResponses.count else { return }

        let firstMessage = predefinedResponses[responseIndex]
        responseIndex += 1

        // Append the first message (Other user's message)
        messages.append((firstMessage, false))

        // Reload table view and scroll to the bottom
        messagesTableView.reloadData()

        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

        // Save updated messages
        if !isNewSession {
            saveMessagesToUserDefaults()
        }
    }
    var placeholderLabel: UILabel!

    func setupUI() {
        view.backgroundColor = .white

        imageModel = UIImageView()
        imageModel.translatesAutoresizingMaskIntoConstraints = false
        imageModel.layer.cornerRadius = 25
        imageModel.clipsToBounds = true
        imageModel.contentMode = .scaleAspectFill
        view.addSubview(imageModel)

        nameModel = UILabel()
        nameModel.translatesAutoresizingMaskIntoConstraints = false
        nameModel.font = .boldSystemFont(ofSize: 18)
        view.addSubview(nameModel)

        currentUserInputField = UITextView()
        currentUserInputField.translatesAutoresizingMaskIntoConstraints = false
        currentUserInputField.layer.borderWidth = 1
        currentUserInputField.layer.borderColor = UIColor.gray.cgColor
        currentUserInputField.layer.cornerRadius = 8
        currentUserInputField.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        currentUserInputField.font = .systemFont(ofSize: 16)
        currentUserInputField.delegate = self
        view.addSubview(currentUserInputField)

        // Create the placeholder label
        placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = "Type a message..."
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.isUserInteractionEnabled = false
        currentUserInputField.addSubview(placeholderLabel)

        sendButton = UIButton(type: .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .blue
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        view.addSubview(sendButton)

        messagesTableView = UITableView()
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        messagesTableView.separatorStyle = .none
        view.addSubview(messagesTableView)

        NSLayoutConstraint.activate([
            imageModel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageModel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            imageModel.widthAnchor.constraint(equalToConstant: 50),
            imageModel.heightAnchor.constraint(equalToConstant: 50),

            nameModel.centerYAnchor.constraint(equalTo: imageModel.centerYAnchor),
            nameModel.leftAnchor.constraint(equalTo: imageModel.rightAnchor, constant: 10),
            nameModel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),

            messagesTableView.topAnchor.constraint(equalTo: nameModel.bottomAnchor, constant: 150),
            messagesTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            messagesTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: currentUserInputField.topAnchor, constant: -50),

            currentUserInputField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            currentUserInputField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10),
            currentUserInputField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            currentUserInputField.heightAnchor.constraint(equalToConstant: 40),

            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40),

            placeholderLabel.topAnchor.constraint(equalTo: currentUserInputField.topAnchor, constant: 10),
            placeholderLabel.leftAnchor.constraint(equalTo: currentUserInputField.leftAnchor, constant: 10),
        ])
      
    }
    var timeLabel: UILabel!  // Declare this as a property of your class

    func setupTimeLabel() {
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabel)

        // Constraints for positioning, assuming personNameLabel exists
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor, constant: 10),
            timeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
    }

    func updateChatTimeLabel(with time: String) {
        // Use guard to safely unwrap timeLabel before updating
        guard let timeLabel = timeLabel else {
            print("Error: timeLabel is nil")
            return
        }

        timeLabel.text = "Last message at: \(time)"
    }

    // MARK: - Clear All Chats Functionality

    func setupClearAllChatsButton() {
        let clearAllChatsButton = UIBarButtonItem(title: "Clear All Chats", style: .plain, target: self, action: #selector(clearAllChats))
        navigationItem.rightBarButtonItem = clearAllChatsButton
    }

    @objc func clearAllChats() {
        let alert = UIAlertController(title: "Clear All Chats", message: "Are you sure you want to clear all messages?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { [weak self] _ in
            self?.clearMessages()
        }))
        
        present(alert, animated: true, completion: nil)
    }

    func clearMessages() {
        // Clear messages from the array
        messages.removeAll()

        // Reload table view
        messagesTableView.reloadData()

        // Clear messages from UserDefaults by removing the stored key
        let uniqueKey = "chatMessages_\(chatName ?? "")"
        UserDefaults.standard.removeObject(forKey: uniqueKey)
        
        // Optionally, reset the UI elements to their initial state
        currentUserInputField.text = ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (message, isCurrentUser) = messages[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as? ChatMessageCell {
            cell.configure(with: message, isCurrentUser: isCurrentUser)
            return cell
        }
        return UITableViewCell()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // If the "Return" key is pressed
            if text == "\n" {
               
                sendMessage()  // Send the message
                return false  // Prevent the "Return" key from adding a newline in the UITextView
            }
       
            return true  // Otherwise, allow text changes as usual
        }
    func setChatTime() {
        // Set the first chat time when the first message is sent or received
        if messages.isEmpty {
            chatTime = getCurrentTime()  // Store the time of the first message
        }
    }

    var hasUpdatedLastMessage: Bool = false
       var lastPredefinedMessage: String? = nil

       @objc func sendMessage() {
           guard let message = currentUserInputField.text, !message.isEmpty else { return }

           let currentTime = getCurrentTime()

           // Append the new message (User's message)
           messages.append((message, true))
           currentUserInputField.text = ""

           // Pass the current time back to the delegate
           delegate?.updateChatTime(newTime: currentTime)

           // Simulate the response from the other user (predefined response) immediately
           simulateOtherUserResponse(time: currentTime)

           // Save the updated messages to UserDefaults only if it's not a new session
           if !isNewSession {
               saveMessagesToUserDefaults()
           }

           // Reload the table view to reflect the user's message
           messagesTableView.reloadData()

           // Scroll to the last message (user's message)
           let indexPath = IndexPath(row: messages.count - 1, section: 0)
           messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

           // Update the last predefined message only if it hasn't been updated yet
           if responseIndex > 0 && responseIndex <= predefinedResponses.count {
               lastPredefinedMessage = predefinedResponses[responseIndex - 1]
               print("Updating last predefined message: \(lastPredefinedMessage ?? "No message")")
               delegate?.updateLastMessage(newMessage: lastPredefinedMessage ?? "")
              
           }
       }

       // Simulate predefined response from the other user
       func simulateOtherUserResponse(time: String) {
           // Ensure there are predefined responses left
           guard responseIndex < predefinedResponses.count else {
               return
           }

           let response = predefinedResponses[responseIndex]
           responseIndex += 1 // Increment index to get the next response for the next message

           // Simulate typing delay (2 seconds)
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               // Append the response from the other user (predefined message)
               self.messages.append((response, false))

               // Pass the current time back to the delegate after the response
               self.delegate?.updateChatTime(newTime: time)

               // Reload table view to show the new message
               self.messagesTableView.reloadData()

               // Scroll to the last message (which is the predefined response)
               let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
               self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

               // Save updated messages
               if !self.isNewSession {
                   self.saveMessagesToUserDefaults()
               }


           }
       }
   

    func saveMessagesToUserDefaults() {
        // Use the personName or any unique identifier to save messages
        let uniqueKey = "chatMessages_\(chatName ?? "")"
        let messageArray = messages.map { ["text": $0.0, "isCurrentUser": $0.1] }
        UserDefaults.standard.set(messageArray, forKey: uniqueKey)
    }

//    func loadMessagesFromUserDefaults() {
//        let uniqueKey = "chatMessages_\(chatName ?? "")"
//        
//        if let savedMessages = UserDefaults.standard.array(forKey: uniqueKey) as? [[String: Any]] {
//            messages = savedMessages.map {
//                let message = $0["text"] as? String ?? ""
//                let isCurrentUser = $0["isCurrentUser"] as? Bool ?? false
//                return (message, isCurrentUser)
//            }
//        }
//        
//        messagesTableView.reloadData()
//        scrollToLastMessage()
//    }
    func loadMessagesFromUserDefaults() {
        let uniqueKey = "chatMessages_\(chatName ?? "")"
        
        if let savedMessages = UserDefaults.standard.array(forKey: uniqueKey) as? [[String: Any]] {
            messages = savedMessages.map {
                let message = $0["text"] as? String ?? ""
                let isCurrentUser = $0["isCurrentUser"] as? Bool ?? false
                return (message, isCurrentUser)
            }
        }
        
        messagesTableView.reloadData()
        DispatchQueue.main.async {
            self.scrollToLastMessage()
        }
    }


    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: Date())
    }

    // MARK: - Swipe Actions for Deletion

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            self.messages.remove(at: indexPath.row)
            self.messagesTableView.deleteRows(at: [indexPath], with: .fade)

            // Save updated messages after deletion
            self.saveMessagesToUserDefaults()

            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Hide placeholder when editing starts
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // Show placeholder if no text is entered
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        // Hide placeholder when text is typed
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
   

}
