//
//  ChatRequestDetailViewController.swift
//  ChatApplication
//
//  Created by student-2 on 24/12/24.
//
import UIKit

protocol ChatRequestDetailDelegate: AnyObject {
    func didCategorizeRequest(_ request: ChatRequest)
}
class ChatRequestDetailViewController: UIViewController {
    
    weak var delegate: ChatRequestDetailDelegate?
    
    // Outlets for UI elements
    @IBOutlet weak var chatRequestDetailImage: UIImageView!
    @IBOutlet weak var chatRequestDetailNameLabel: UILabel!
    @IBOutlet weak var chatRequestDetailMessageLabel: UILabel!
    @IBOutlet weak var chatRequestDetailImage2: UIImageView!
    
    // Chat request object to display details
    var chatRequest: ChatRequest?
    
    // Buttons for accepting or rejecting the request
    var acceptButton: UIButton!
    var rejectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Safely unwrap chatRequest to avoid force-unwrapping
        if let request = chatRequest {
            chatRequestDetailImage.image = request.image
            chatRequestDetailNameLabel.text = request.name
            chatRequestDetailMessageLabel.text = request.message
            chatRequestDetailImage2.image = request.image
        } else {
            print("Error: chatRequest is nil")
        }

        setupButtons()
        applyImageStyle()
    }
    func applyImageStyle() {
        // Apply border and shadow only to chatRequestDetailImage
        chatRequestDetailImage.layer.borderColor = UIColor.black.cgColor
        chatRequestDetailImage.layer.borderWidth = 1.0
        chatRequestDetailImage.layer.cornerRadius = 10
        chatRequestDetailImage.layer.masksToBounds = true  // Ensures the border applies properly
        
        // Apply shadow effect
        chatRequestDetailImage.layer.shadowColor = UIColor.black.cgColor
        chatRequestDetailImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatRequestDetailImage.layer.shadowOpacity = 0.9
        chatRequestDetailImage.layer.shadowRadius = 4.0
        
        chatRequestDetailImage2.layer.borderColor = UIColor.black.cgColor
        chatRequestDetailImage2.layer.borderWidth = 1.0
           chatRequestDetailImage2.layer.cornerRadius = 10
           chatRequestDetailImage2.layer.masksToBounds = true  // Ensures the border applies properly
           // Apply shadow effect
           chatRequestDetailImage2.layer.shadowColor = UIColor.black.cgColor
           chatRequestDetailImage2.layer.shadowOffset = CGSize(width: 0, height: 2)
           chatRequestDetailImage2.layer.shadowOpacity = 0.9
           chatRequestDetailImage2.layer.shadowRadius = 4.0
    }
    // Set up Accept and Reject buttons
    func setupButtons() {
        acceptButton = UIButton(type: .system)
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        acceptButton.backgroundColor = .lightGray
        acceptButton.layer.cornerRadius = 10
        acceptButton.addTarget(self, action: #selector(acceptRequestTapped), for: .touchUpInside)
        
        rejectButton = UIButton(type: .system)
        rejectButton.setTitle("Reject", for: .normal)
        rejectButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rejectButton.backgroundColor = .lightGray
        rejectButton.layer.cornerRadius = 10
        rejectButton.addTarget(self, action: #selector(rejectRequestTapped), for: .touchUpInside)
        
        let buttonStackView = UIStackView(arrangedSubviews: [acceptButton, rejectButton])
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        buttonStackView.alignment = .fill
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            buttonStackView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 100)
        ])
    }
    
    // Action when Accept button is tapped
    @objc func acceptRequestTapped() {
        print("-----------------------------Inside accept--------------------------------")
        acceptButton.isHidden = true
        rejectButton.isHidden = true
        showCategorizationOptions()
    }
    
    // Action when Reject button is tapped
//    @objc func rejectRequestTapped() {
//        acceptButton.isHidden = true
//        rejectButton.isHidden = true
//        let alertController = UIAlertController(title: "Reject Request", message: "Are you sure you want to reject this chat request?", preferredStyle: .alert)
//        let rejectAction = UIAlertAction(title: "Reject", style: .destructive) { [weak self] _ in
//            self?.navigationController?.popViewController(animated: true)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(rejectAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
    @objc func rejectRequestTapped() {
        acceptButton.isHidden = true
        rejectButton.isHidden = true
        let alertController = UIAlertController(
            title: "Reject Request",
            message: "Are you sure you want to reject this chat request? This action is permanent.",
            preferredStyle: .alert
        )
        
        let rejectAction = UIAlertAction(title: "Reject", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            if let chatRequest = self.chatRequest {
                // Remove the chat request from the data source
                if let index = ChatRequestTableViewController.chatRequests.firstIndex(where: { $0 === chatRequest }) {
                    ChatRequestTableViewController.chatRequests.remove(at: index)
                    print("Chat request permanently removed at index: \(index)")
                } else {
                    print("ChatRequest not found in the array.")
                }
            } else {
                print("chatRequest is nil.")
            }
            
            // Navigate back to the previous screen
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(rejectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    
    // Show categorization options when Accept is tapped
    private func showCategorizationOptions() {
        let alertController = UIAlertController(title: "Categorize Request", message: "Please choose a category", preferredStyle: .alert)
        
        let generalAction = UIAlertAction(title: "General", style: .default) { [weak self] _ in
            self?.categorizeRequest(as: .general)
        }
        
        let businessAction = UIAlertAction(title: "Business", style: .default) { [weak self] _ in
            self?.categorizeRequest(as: .business)
        }
        
        alertController.addAction(generalAction)
        alertController.addAction(businessAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Categorize the request based on the chosen category
    private func categorizeRequest(as category: ChatRequestCategory) {
       
        print("------------------------\(chatRequest?.name)------------------------")
//        print(ChatRequestTableViewController.chatRequests.find(chatRequest))
        if let chatRequest = chatRequest {
            if let index = ChatRequestTableViewController.chatRequests.firstIndex(where: { $0 === chatRequest }) {
                ChatRequestTableViewController.chatRequests.remove(at: index)
//                print("Found chatRequest at index: \(index)")
            } else {
//                print("ChatRequest not found in the array.")
            }
        } else {
//            print("chatRequest is nil.")
        }


        guard let request = chatRequest else { return }
        request.category = category
        delegate?.didCategorizeRequest(request)
//
//        // Update the chat requests after categorization
//        if let navigationController = navigationController {
//                for viewController in navigationController.viewControllers {
//                    if let chatVC = viewController as? ChatViewController {
//                        navigationController.popToViewController(chatVC, animated: true)
//                        return
//                    }
//                }
//            }
//
//            // Fallback to pop the current view controller
//            navigationController?.popViewController(animated: true)
//        navigateBackToChatViewController()
    }
    private func navigateBackToChatViewController() {
        guard let navigationController = navigationController else { return }
        
        for viewController in navigationController.viewControllers {
            if let chatVC = viewController as? ChatViewController {
                // Found ChatViewController in the stack, pop to it
                navigationController.popToViewController(chatVC, animated: true)
                return
            }
        }
        
        // If ChatViewController is not in the stack (unlikely in your flow), fallback
        navigationController.popToRootViewController(animated: true)
    }

}
