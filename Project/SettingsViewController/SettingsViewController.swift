
import UIKit
import PhotosUI

class SettingsViewController: UIViewController {
    
    private let bigLabel = UILabel(text: "EDITING PROFILE", font: .robotoBold24(), textColor: .specialGray)
    
    private lazy var closeButton = CloseButton(type: .system)
    private lazy var saveButton = GreenButton(text: "SAVE")
    
    private let addPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.image = UIImage(named: "addPhoto")
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let firstNameLabel = UILabel(text: "First name")
    private let firstNameTextField = BrownTextField()
    
    private let secondNameLabel = UILabel(text: "Second name")
    private let secondNameTextField = BrownTextField()
    
    private let heightNameLabel = UILabel(text: "Height")
    private let heightNameTextField = BrownTextField()
    
    private let weightNameLabel = UILabel(text: "Weight")
    private let weightNameTextField = BrownTextField()
    
    private let targetLabel = UILabel(text: "   Target")
    private let targetTextField = BrownTextField()
    
    
    private var firstStackView = UIStackView()
    private var secondStackView = UIStackView()
    private var heightStackView = UIStackView()
    private var weightStackView = UIStackView()
    private var targetStackView = UIStackView()
    private var generalStackView = UIStackView()
    
    private var userModel = UserModel()
    
    override func viewDidLayoutSubviews() {
        addPhotoImageView.layer.cornerRadius = addPhotoImageView.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        addTaps()
        loadUserInfo()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(bigLabel)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        view.addSubview(userBackgroundView)
        view.addSubview(addPhotoImageView)
        
        firstStackView = UIStackView(arrangedSubviews: [firstNameLabel, firstNameTextField], axis: .vertical, spacing: 3)
        secondStackView = UIStackView(arrangedSubviews: [secondNameLabel, secondNameTextField], axis: .vertical, spacing: 3)
        heightStackView = UIStackView(arrangedSubviews: [heightNameLabel, heightNameTextField], axis: .vertical, spacing: 3)
        weightStackView = UIStackView(arrangedSubviews: [weightNameLabel, weightNameTextField], axis: .vertical, spacing: 3)
        targetStackView = UIStackView(arrangedSubviews: [targetLabel, targetTextField], axis: .vertical, spacing: 3)
        generalStackView = UIStackView(arrangedSubviews: [firstStackView, secondStackView, heightStackView, weightStackView, targetStackView], axis: .vertical, spacing: 15)
        view.addSubview(generalStackView)
        
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        setUserModel()
        
        let usersArray = RealmManager.shared.getResultUserModel()
        
        if usersArray.count == 0 {
            RealmManager.shared.saveUserModel(userModel)
        } else {
            RealmManager.shared.updateUserModel(userModel)
        }
        userModel = UserModel()
    }
    private func addTaps() {
        let tapImageView = UITapGestureRecognizer(target: self, action: #selector(setUserPhoto))
        addPhotoImageView.isUserInteractionEnabled = true
        addPhotoImageView.addGestureRecognizer(tapImageView)
    }
    
    @objc private func setUserPhoto() {
        alertPhotoOrCamera { [weak self] sourse in
            guard let self = self else { return }
            
            if #available(iOS 14.0, *) {
                self.presentPHPicker()
            } else {
                self.chooseImagePicker(sourse: sourse)
            }
        }
    }
    
    private func setUserModel() {
        
        guard let firstName = firstNameTextField.text,
              let secondName = secondNameTextField.text,
              let height = heightNameTextField.text,
              let weight = weightNameTextField.text,
              let target = targetTextField.text else {
            return
        }
        
        guard let intWeight = Int(weight),
              let intHeight = Int(height),
              let target = Int(target) else {
            return
        }
        
        userModel.userFirstName = firstName
        userModel.userSecondName = secondName
        userModel.userHeigh = intHeight
        userModel.userWeight = intWeight
        userModel.userTarget = target
        
        if addPhotoImageView.image == UIImage(named: "addPhoto") {
            userModel.userImage = nil
        } else {
            guard let imageData = addPhotoImageView.image?.pngData() else {
                return
            }
            userModel.userImage = imageData
        }
    }
    
    private func loadUserInfo() {
        let userArray = RealmManager.shared.getResultUserModel()
        
        if userArray.count != 0 {
            firstNameTextField.text = userArray[0].userFirstName
            secondNameTextField.text = userArray[0].userSecondName
            heightNameTextField.text = "\(userArray[0].userHeigh)"
            weightNameTextField.text = "\(userArray[0].userWeight)"
            targetTextField.text = "\(userArray[0].userTarget)"
            
            guard let data = userArray[0].userImage,
            let image = UIImage(data: data) else {return}
            
            addPhotoImageView.image = image
            addPhotoImageView.contentMode = .scaleAspectFit
        }
    }
}
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        addPhotoImageView.image = image
        addPhotoImageView.contentMode = .scaleAspectFit
        dismiss(animated: true)
    }
}
// MARK: - PHPickerViewControllerDelegate

@available(iOS 14.0, *)
extension SettingsViewController: PHPickerViewControllerDelegate {
  
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.addPhotoImageView.image = image
                    self.addPhotoImageView.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    private func presentPHPicker() {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images])
        
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
}
// MARK: - SetConstraints

extension SettingsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            bigLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            bigLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigLabel.heightAnchor.constraint(equalToConstant: 25),
            
            closeButton.centerYAnchor.constraint(equalTo: bigLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            userBackgroundView.topAnchor.constraint(equalTo: addPhotoImageView.centerYAnchor),
            userBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            userBackgroundView.heightAnchor.constraint(equalToConstant: 90),
            
            addPhotoImageView.topAnchor.constraint(equalTo: bigLabel.bottomAnchor, constant: 20),
            addPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            addPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40),
            secondNameTextField.heightAnchor.constraint(equalToConstant: 40),
            heightNameTextField.heightAnchor.constraint(equalToConstant: 40),
            weightNameTextField.heightAnchor.constraint(equalToConstant: 40),
            targetTextField.heightAnchor.constraint(equalToConstant: 40),

            
            generalStackView.topAnchor.constraint(equalTo: userBackgroundView.bottomAnchor, constant: 20),
            generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
