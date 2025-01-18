import UIKit

class ChangePasswordViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Password"
        
        // Configure the Save button in the navigation bar
        configureSaveButton()
    }
    
    // MARK: - Configure Navigation Bar Save Button
    private func configureSaveButton() {
        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePasswordTapped))
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    // MARK: - Actions
    @objc func savePasswordTapped() {
        // Validate input
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty,
              let newPassword = newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        // Validate current password from UserDefaults (or the hardcoded value initially)
        let savedPassword = UserDefaults.standard.string(forKey: "userPassword") ?? "cidny" // Default to 'cidny' if no saved password
        if currentPassword != savedPassword {
            showAlert(message: "Current password is incorrect.")
            return
        }
        
        // Validate new password and confirm password
        if newPassword != confirmPassword {
            showAlert(message: "New password and confirm password do not match.")
            return
        }
        
        // Save the new password to UserDefaults
        UserDefaults.standard.set(newPassword, forKey: "userPassword")
        showAlert(message: "Password changed successfully!") {
            // Redirect back to the previous screen
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Helper Methods
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
