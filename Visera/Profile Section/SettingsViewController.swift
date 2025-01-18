//
//  SettingsViewController.swift
//  Visera
//
//  Created by student-2 on 19/12/24.
//

import UIKit

class SettingsViewController: UIViewController {

   
    @IBOutlet weak var viewPortfolioButton: UIButton!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyGradientToButton()
    }

    func applyGradientToButton() {
        let gradientLayer = CAGradientLayer()

        // Define gradient colors
        gradientLayer.colors = [
            UIColor(red: 162/255, green: 121/255, blue: 13/255, alpha: 1).cgColor,
            UIColor(red: 187/255, green: 155/255, blue: 90/255, alpha: 1).cgColor,
            UIColor(red: 187/255, green: 155/255, blue: 90/255, alpha: 1).cgColor,
            UIColor(red: 162/255, green: 121/255, blue: 13/255, alpha: 1).cgColor,
            UIColor(red: 187/255, green: 155/255, blue: 73/255, alpha: 1).cgColor
        ]

        // Calculate gradient direction for 310.6 degrees
        let gradientPoints = calculateGradientPoints(for: 310.6)
        gradientLayer.startPoint = gradientPoints.start
        gradientLayer.endPoint = gradientPoints.end

        // Set the gradient frame to match the button bounds
        gradientLayer.frame = viewPortfolioButton.bounds

        // Apply corner radius
        let maxCornerRadius = viewPortfolioButton.frame.height / 2
        viewPortfolioButton.layer.cornerRadius = maxCornerRadius
        viewPortfolioButton.layer.masksToBounds = true

        // Clip gradient layer corners to match button
        gradientLayer.cornerRadius = maxCornerRadius

        // Add gradient layer to button
        viewPortfolioButton.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    func calculateGradientPoints(for angle: CGFloat) -> (start: CGPoint, end: CGPoint) {
        let radians = angle * .pi / 180
        let startX = 0.5 + 0.5 * cos(radians + .pi)
        let startY = 0.5 + 0.5 * sin(radians + .pi)
        let endX = 0.5 + 0.5 * cos(radians)
        let endY = 0.5 + 0.5 * sin(radians)
        return (start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
    }

}
