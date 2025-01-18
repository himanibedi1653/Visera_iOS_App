//
//  EventsDetailViewController.swift
//  Visera-HomeScreen
//
//  Created by student-2 on 16/01/25.
//

import UIKit
import SafariServices

class EventsDetailViewController: UIViewController {
    var event: Event?
    
    
    @IBOutlet weak var eventBannerImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var RegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let event = event {
            
            eventBannerImage.image = event.portraitImage
            
            
            let attributedString = NSMutableAttributedString()
            
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor(red: 162/255, green: 121/255, blue: 13/255, alpha: 1) // Title color
            ]
            let titleText = NSAttributedString(string: "\(event.title)\n\n", attributes: titleAttributes)
            attributedString.append(titleText)
            
            
            let registrationLastDateTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let registrationLastDateTitleText = NSAttributedString(string: "Registration Last Date: ", attributes: registrationLastDateTitleAttributes)
            let registrationLastDateAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18)
            ]
            let registrationLastDateText = NSAttributedString(string: "\(event.registrationLastDate ?? "N/A")\n\n", attributes: registrationLastDateAttributes)
            attributedString.append(registrationLastDateTitleText)
            attributedString.append(registrationLastDateText)
            
            
            let descriptionTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let descriptionTitleText = NSAttributedString(string: "Description: ", attributes: descriptionTitleAttributes)
            let descriptionText = NSAttributedString(string: "\(event.description ?? "N/A")\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
            attributedString.append(descriptionTitleText)
            attributedString.append(descriptionText)
            
            
            let eventDateTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let eventDateTitleText = NSAttributedString(string: "Event Date: ", attributes: eventDateTitleAttributes)
            let eventDateText = NSAttributedString(string: "\(event.eventDate ?? "N/A")\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
            attributedString.append(eventDateTitleText)
            attributedString.append(eventDateText)


            let locationTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let locationTitleText = NSAttributedString(string: "Location: ", attributes: locationTitleAttributes)
            let locationText = NSAttributedString(string: "\(event.location ?? "N/A")\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
            attributedString.append(locationTitleText)
            attributedString.append(locationText)
            
            
            let additionalInformationTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let additionalInformationTitleText = NSAttributedString(string: "Additional Information: ", attributes: additionalInformationTitleAttributes)
            let additionalInformationText = NSAttributedString(string: "\(event.additionalInformation ?? "N/A")\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
            attributedString.append(additionalInformationTitleText)
            attributedString.append(additionalInformationText)
            
            
            let dressThemeTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let dressThemeTitleText = NSAttributedString(string: "Dress Theme: ", attributes: dressThemeTitleAttributes)
            let dressThemeText = NSAttributedString(string: "\(event.dressTheme ?? "N/A")\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
            attributedString.append(dressThemeTitleText)
            attributedString.append(dressThemeText)
            
            
            let ageRangeTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let ageRangeTitleText = NSAttributedString(string: "Age Range: ", attributes: ageRangeTitleAttributes)
            let ageRangeText = NSAttributedString(string: "\(event.startingAge ?? 0) - \(event.endingAge ?? 0)\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
            attributedString.append(ageRangeTitleText)
            attributedString.append(ageRangeText)
            
            
            let genderTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let genderTitleText = NSAttributedString(string: "Gender: ", attributes: genderTitleAttributes)
            let genderText = NSAttributedString(string: "\(event.gender.map { $0.rawValue }.joined(separator: ", "))\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
            attributedString.append(genderTitleText)
            attributedString.append(genderText)
            
            
            let languagesTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let languagesTitleText = NSAttributedString(string: "Languages: ", attributes: languagesTitleAttributes)
            let languagesText = NSAttributedString(string: "\(event.languages.joined(separator: ", "))\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
            attributedString.append(languagesTitleText)
            attributedString.append(languagesText)
            
            
            eventNameLabel.attributedText = attributedString
            
            
            if let registrationLink = event.registrationLink {
                RegisterButton.addTarget(self, action: #selector(RegisterButtonTapped), for: .touchUpInside)
                RegisterButton.accessibilityValue = registrationLink.absoluteString
            }
            
            
            RegisterButton.layer.borderColor = UIColor(red: 187/255, green: 155/255, blue: 73/255, alpha: 1).cgColor
            RegisterButton.layer.borderWidth = 3
            RegisterButton.setTitleColor(UIColor(red: 162/255, green: 121/255, blue: 13/255, alpha: 1), for: .normal)
            RegisterButton.layer.cornerRadius =  20
        }
    }

    
    @objc func RegisterButtonTapped(_ sender: UIButton) {
        if let urlString = sender.accessibilityValue, let url = URL(string: urlString) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }
}
