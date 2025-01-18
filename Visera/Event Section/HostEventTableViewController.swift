//
//  HostEventTableViewController.swift
//  Visera-HomeScreen
//
//  Created by student-2 on 17/01/25.
//

import UIKit

class HostEventTableViewController: UITableViewController, LocationSelectionDelegate {
    @IBOutlet weak var LocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickLocationTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mapkitVC = storyboard.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController {
            mapkitVC.delegate = self
            navigationController?.pushViewController(mapkitVC, animated: true)
        }
    }
    
    func didSelectLocation(_ location: String) {
        LocationLabel.text = location
    }

}
