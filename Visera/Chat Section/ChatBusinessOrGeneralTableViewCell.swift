//
//  ChatBusinessOrGeneralTableViewCell.swift
//  ChatApplication
//
//  Created by student-2 on 24/12/24.
//

import UIKit

class ChatBusinessOrGeneralTableViewCell: UITableViewCell {

    
    @IBOutlet weak var chatBusinessOrGeneralImage: UIImageView!
    
    
    @IBOutlet weak var chatBusinessOrGeneralName: UILabel!
    
    
    
    @IBOutlet weak var chatBusinessOrGeneralMessage: UILabel!
    
    
    @IBOutlet weak var chatBusinessOrGeneralTime: UILabel!
    
 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with request: ChatRequest) {
           chatBusinessOrGeneralImage.image = request.image
           chatBusinessOrGeneralName.text = request.name
           chatBusinessOrGeneralMessage.text = request.message
           chatBusinessOrGeneralTime.text = request.time

           // Optional: Round the image to create a circular avatar
           chatBusinessOrGeneralImage.layer.cornerRadius = chatBusinessOrGeneralImage.frame.size.width / 2
           chatBusinessOrGeneralImage.clipsToBounds = true
       }

}
