//
//  HomeNotificationTableViewCell.swift
//  Visera
//
//  Created by student-2 on 20/12/24.
//

import UIKit

class HomeNotificationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var homeNotificationNameLabel: UILabel!
    
    
    
    func configure(with notification: HomeNotification) {
            homeNotificationNameLabel.text = notification.homeNotificationName
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
