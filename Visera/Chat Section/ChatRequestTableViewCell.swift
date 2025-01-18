//
//  ChatRequestTableViewCell.swift
//  ChatApplication
//
//  Created by student-2 on 24/12/24.
//

import UIKit

class ChatRequestTableViewCell: UITableViewCell {

   
    @IBOutlet weak var chatRequestImage: UIImageView!
    
    @IBOutlet weak var chatRequestNameLabel: UILabel!
    
    @IBOutlet weak var chatRequestMessageLabel: UILabel!
    
    @IBOutlet weak var chatRequestTimeLabel: UILabel!
    
    
    func configure(with request: ChatRequest) {
            chatRequestImage.image = request.image
            chatRequestNameLabel.text = request.name
            chatRequestMessageLabel.text = request.message
            chatRequestTimeLabel.text = request.time
//        chatRequestImage.layer.borderColor = UIColor.black.cgColor
//        chatRequestImage.layer.borderWidth = 0.8
//            chatRequestImage.layer.cornerRadius = chatRequestImage.frame.size.width / 2  // For a circular avatar
//            chatRequestImage.layer.masksToBounds = true  // Ensures the border applies properly
//            
//            // Apply shadow effect to the image
//            chatRequestImage.layer.shadowColor = UIColor.black.cgColor
//            chatRequestImage.layer.shadowOffset = CGSize(width: 0, height: 2)
//            chatRequestImage.layer.shadowOpacity = 0.9
//            chatRequestImage.layer.shadowRadius = 4.0
            // Optional: Round the image to create a circular avatar
//            chatRequestImage.layer.cornerRadius = chatRequestImage.frame.size.width / 2
//            chatRequestImage.clipsToBounds = true
        }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
