import UIKit

class PersonalInformationViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var editProfileButton: UIButton! // Ensure this is connected in Storyboard

    // Variables to store user information
    var name: String = ""
    var username: String = ""
    var dateOfBirth: Date = Date()
    var email: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load saved information from UserDefaults
        loadSavedInformation()

        // Set default values to UI
        nameTextField.text = name
        usernameTextField.text = username
        emailTextField.text = email
        dateOfBirthPicker.date = dateOfBirth

        // Make profile image rounded
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true

        // Set delegates for text fields
        nameTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self

        // Load saved profile image (this will show the image when the view loads)
        loadSavedProfileImage()
    }

    // MARK: - UITextFieldDelegate Methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Automatically save changes when editing ends
        if textField == nameTextField {
            name = textField.text ?? ""
        } else if textField == usernameTextField {
            username = textField.text ?? ""
        } else if textField == emailTextField {
            email = textField.text ?? ""
        }
    }

    // Optional: Save when user presses "Return" (if keyboard has a return button)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss keyboard
        return true
    }

    // MARK: - Actions
    @IBAction func dateOfBirthChanged(_ sender: UIDatePicker) {
        // Automatically save the date of birth when it changes
        dateOfBirth = sender.date
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // Save all the current information to variables
        name = nameTextField.text ?? ""
        username = usernameTextField.text ?? ""
        dateOfBirth = dateOfBirthPicker.date
        email = emailTextField.text ?? ""

        // Save the information to UserDefaults
        saveInformation()

        // Navigate back to the previous screen
        navigationController?.popViewController(animated: true)
    }

    @IBAction func editProfileImageTapped(_ sender: UIButton) {
        // Action when the edit profile image button is tapped
        let alertController = UIAlertController(title: "Edit Profile Picture", message: "Choose an option", preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.openImagePicker(sourceType: .camera)
            }))
        }

        alertController.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        }))
        
        alertController.addAction(UIAlertAction(title: "Choose from Files", style: .default, handler: { _ in
            self.openImagePicker(sourceType: .savedPhotosAlbum)
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Image Picker for Profile Picture
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
            saveProfileImage(image: editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
            saveProfileImage(image: originalImage)
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Save and Load Functions
    private func saveInformation() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(name, forKey: "name")
        userDefaults.set(username, forKey: "username")
        userDefaults.set(dateOfBirth, forKey: "dateOfBirth")
        userDefaults.set(email, forKey: "email")
        userDefaults.synchronize()
    }

    private func loadSavedInformation() {
        let userDefaults = UserDefaults.standard
        name = userDefaults.string(forKey: "name") ?? "cidnycrawford"
        username = userDefaults.string(forKey: "username") ?? "cidnycrawford"
        dateOfBirth = userDefaults.object(forKey: "dateOfBirth") as? Date ?? Date()
        email = userDefaults.string(forKey: "email") ?? "cidnycrawford@gmail.com"
        
        // Load profile image
        loadSavedProfileImage()
    }

    private func saveProfileImage(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(imageData, forKey: "profileImage")
            userDefaults.synchronize()
        }
    }

    private func loadSavedProfileImage() {
        let userDefaults = UserDefaults.standard
        if let imageData = userDefaults.data(forKey: "profileImage"),
           let savedImage = UIImage(data: imageData) {
            profileImageView.image = savedImage
        } else {
            profileImageView.image = UIImage(named: "defaultProfileImage") // Set a default image if none found
        }
    }
}
