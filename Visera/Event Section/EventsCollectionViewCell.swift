//
//  EventsCollectionViewCell.swift
//  Events
//
//  Created by student-2 on 14/01/25.
//

import UIKit

class EventsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setting the corner radius
        eventImage.layer.cornerRadius = 20
        eventImage.layer.masksToBounds = true // Ensures the image is clipped to bounds
    }
    
    
    
}
