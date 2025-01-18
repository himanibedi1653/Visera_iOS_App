//
//  ProfileSkillsViewController.swift
//  Visera
//
//  Created by Divya Arora on 14/01/25.
//

import UIKit

class ProfileSkillsViewController: UIViewController {

    // IBOutlets for each button
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var button12: UIButton!
    @IBOutlet weak var button13: UIButton!
    @IBOutlet weak var button14: UIButton!
    @IBOutlet weak var button15: UIButton!
    @IBOutlet weak var button16: UIButton!
    @IBOutlet weak var button17: UIButton!
    @IBOutlet weak var button18: UIButton!
    @IBOutlet weak var button19: UIButton!
    @IBOutlet weak var button20: UIButton!
    @IBOutlet weak var button21: UIButton!
    @IBOutlet weak var button22: UIButton!
    @IBOutlet weak var button23: UIButton!
    @IBOutlet weak var button24: UIButton!

    // Outlet for the selection count label
    @IBOutlet weak var selectionCountLabel: UILabel!

    // Dictionary to track the toggle state of each button
    private var buttonStates: [Int: Bool] = [:]

    // Constant highlight color (golden)
    private let highlightColor = UIColor(red: 187/255, green: 155/255, blue: 90/255, alpha: 1.0)

    // Counter for the number of selected buttons
    private var selectedCount = 0 {
        didSet {
            // Update the label text whenever the count changes
            selectionCountLabel.text = "\(selectedCount)/6"
        }
    }

    // Array to hold selected skill names
    private var selectedSkills: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        styleButtons()

        // Load selected skills from UserDefaults
        if let savedSkills = UserDefaults.standard.array(forKey: "selectedSkills") as? [String] {
            selectedSkills = savedSkills
            selectedCount = selectedSkills.count

            // Update button states based on saved selected skills
            for button in allButtons() {
                if let skill = button.titleLabel?.text, selectedSkills.contains(skill) {
                    button.backgroundColor = highlightColor
//                    button.setTitleColor(.white, for: .normal)
                    button.setAttributedTitle(NSAttributedString(string: button.titleLabel!.text!, attributes: [.foregroundColor: UIColor.white]), for: .normal)
                    buttonStates[button.tag] = true
                }
            }
        }

        selectionCountLabel.text = "\(selectedCount)/6"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for button in allButtons() {
            button.layer.cornerRadius = button.frame.height / 2
        }
        
        //button17.setTitleColor(.white, for: .normal)
    }

    // Function to style all buttons initially
    func styleButtons() {
        for button in allButtons() {
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.borderWidth = 1.0
            button.clipsToBounds = true
            button.backgroundColor = .white
            button.setTitleColor(UIColor(red: 187/255, green: 155/255, blue: 90/255, alpha: 1.0), for: .normal) // Set text color to golden initially
            buttonStates[button.tag] = false
        }
    }

    // IBAction for each button
    @IBAction func buttonTapped(_ sender: UIButton) {
        
       
        // Check if the button is already selected
        if let isColored = buttonStates[sender.tag], isColored {
            // Deselect the button (reset to original state)
            sender.backgroundColor = .white // Reset background color to white
            sender.setAttributedTitle(NSAttributedString(string: sender.titleLabel!.text!, attributes: [.foregroundColor: highlightColor]), for: .normal) // Reset text color to golden
            buttonStates[sender.tag] = false
            selectedCount -= 1

            // Remove skill from selectedSkills
            if let skill = sender.titleLabel?.text, let index = selectedSkills.firstIndex(of: skill) {
                selectedSkills.remove(at: index)
            }
        } else if selectedCount < 6 {
            // Highlight the button (selected state)
            sender.backgroundColor = highlightColor // Set background color to golden
            sender.setAttributedTitle(NSAttributedString(string: sender.titleLabel!.text!, attributes: [.foregroundColor: UIColor.white]), for: .normal)
            buttonStates[sender.tag] = true
            selectedCount += 1


            // Add skill to selectedSkills
            if let skill = sender.titleLabel?.text {
                selectedSkills.append(skill)
            }
        }

        // Update the selection count label after each toggle
        selectionCountLabel.text = "\(selectedCount)/6"
    }

    // IBAction for Save button
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // Save selected skills to UserDefaults
        UserDefaults.standard.set(selectedSkills, forKey: "selectedSkills")

        // Print to confirm the saved data
        print("Selected Skills saved: \(selectedSkills)")

        // Pop the current view controller to go back to the previous screen
        self.navigationController?.popViewController(animated: true)
    }

    // Helper function to get all buttons
    func allButtons() -> [UIButton] {
        return [
            button1, button2, button3, button4, button5, button6,
            button7, button8, button9, button10, button11, button12,
            button13, button14, button15, button16, button17, button18,
            button19, button20, button21, button22, button23, button24
        ]
    }
}
