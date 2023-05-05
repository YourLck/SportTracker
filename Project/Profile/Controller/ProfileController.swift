
import UIKit

struct ResultWorkout {
    
    let name: String
    let result: Int
    let imageData: Data?
}

class ProfileController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 5  - расстояние между ячейками/ Использвовал способ в UICollectionViewDelegateFlowLayout(2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        return collectionView
        }()
    
    private let idProfileCollectionCell = "idProfileCollectionCell"
    
    private let profile = UILabel(text: "PROFILE", font: .robotoMedium24(), textColor: .specialGray)
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.7607843137, blue: 0.7607843137, alpha: 1)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
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
    
    private let userNameLabel = UILabel(text: "Nikita Nemtsu", font: .robotoBold24(), textColor: .white)
    private let userHeightLabel = UILabel(text: "Height: ", font: .robotoBold16(), textColor: .specialGray)
    private let userWeightLabel = UILabel(text: "Weight: ", font: .robotoBold16(), textColor: .specialGray)
    
    private lazy var  editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "editing")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Editing", for: .normal)
        button.tintColor = .specialGreen
        button.titleLabel?.font = .robotoMedium16()
        button.semanticContentAttribute = .forceRightToLeft // перенос картинки на право
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let targetView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .specialBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .specialBrown
        progressView.progressTintColor = .specialGreen
        progressView.layer.cornerRadius = 14
        progressView.clipsToBounds = true
        progressView.setProgress(0, animated: false)
        progressView.layer.sublayers?[1].cornerRadius = 14
        progressView.subviews[1].clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let targetLabel = UILabel(text: "TARGET: 0 workouts", font: .robotoBold16(), textColor: .specialGray)
    private let workoutsNowLabel = UILabel(text: "0", font: .robotoBold24(), textColor: .specialGray)
    private let workoutsTargetLabel = UILabel(text: "0", font: .robotoBold24(), textColor: .specialGray)

    private var valueStackView = UIStackView()
    
    private var targetStackView = UIStackView()
    
    private let profileView = ProfileCollectionViewCell()
    
    private var resultWorkout = [ResultWorkout]()
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resultWorkout = [ResultWorkout]()
        getWorkoutResults()
        collectionView.reloadData()
        setupUserParameters()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(profile)
        
        view.addSubview(userBackgroundView)
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        
        valueStackView = UIStackView(arrangedSubviews: [userHeightLabel, userWeightLabel], axis: .horizontal, spacing: 10)
        view.addSubview(valueStackView)
        
        view.addSubview(editingButton)
        view.addSubview(collectionView)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: idProfileCollectionCell)
        
        view.addSubview(targetLabel)
        targetStackView = UIStackView(arrangedSubviews: [workoutsNowLabel, workoutsTargetLabel], axis: .horizontal, spacing: 10)
        view.addSubview(targetStackView)
        
        view.addSubview(progressView)
    }

    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    @objc private func editingButtonTapped() {
        let settingsViewController = SettingsViewController()
        settingsViewController.modalPresentationStyle = .fullScreen
        present(settingsViewController, animated: true)
    }
    
    private func getWorkoutsName() -> [String] {
        var nameArray = [String]()
        
        let allWorkouts = RealmManager.shared.getResultWorkoutModel()
        
        for workoutModel in allWorkouts {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getWorkoutResults() {
        
        let nameArray = getWorkoutsName()
        let workoutArray = RealmManager.shared.getResultWorkoutModel()
        
        for name in nameArray {
            let predicateName = NSPredicate(format: "workoutName = '\(name)'")
            let filteredArray = workoutArray.filter(predicateName).sorted(byKeyPath: "workoutName")
            var result = 0
            var image: Data?
            filteredArray.forEach { model in
                result += model.workoutReps
                image = model.workoutImage
            }
            let resultModel = ResultWorkout(name: name, result: result, imageData: image)
            resultWorkout.append(resultModel)
        }
    }
    
    private func setupUserParameters() {
        
        let usserArray = RealmManager.shared.getResultUserModel()
        
        if usserArray.count != 0 {
            userNameLabel.text = usserArray[0].userFirstName + " " + usserArray[0].userSecondName
            userHeightLabel.text = "Height: \(usserArray[0].userHeigh)"
            userWeightLabel.text = "Weight: \(usserArray[0].userWeight)"
            targetLabel.text = "Target \(usserArray[0].userTarget)"
            workoutsTargetLabel.text = "\(usserArray[0].userTarget)"
            
            guard let data = usserArray[0].userImage,
                  let image = UIImage(data: data) else {
                return
            }
            userPhotoImageView.image = image
        }
    }
}
//MARK: - UICollectionViewDataSource

extension ProfileController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultWorkout.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idProfileCollectionCell,
                                                           for: indexPath) as? ProfileCollectionViewCell else {
           return UICollectionViewCell()
       }
        let model = resultWorkout[indexPath.row]
        cell.cellConfigure(model: model)
        cell.backgroundColor = (indexPath.row % 4 == 0 || indexPath.row % 4 == 3 ? .specialGreen : .specialYellow)
        
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2.07,
               height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        progressView.setProgress(0.6, animated: true)
    }
}
//MARK: - SetConstraints

extension ProfileController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profile.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profile.heightAnchor.constraint(equalToConstant: 25),
            
            userBackgroundView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            userBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            userBackgroundView.heightAnchor.constraint(equalToConstant: 120),
            
            userPhotoImageView.topAnchor.constraint(equalTo: profile.bottomAnchor, constant: 20),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            userNameLabel.bottomAnchor.constraint(equalTo: userBackgroundView.bottomAnchor, constant: -10),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            valueStackView.topAnchor.constraint(equalTo: userBackgroundView.bottomAnchor, constant: 5),
            valueStackView.leadingAnchor.constraint(equalTo: userBackgroundView.leadingAnchor, constant: 25),
            
            editingButton.topAnchor.constraint(equalTo: userBackgroundView.bottomAnchor, constant: 5),
            editingButton.trailingAnchor.constraint(equalTo: userBackgroundView.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: valueStackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            
            targetLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            targetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            targetStackView.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 20),
            targetStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            targetStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            progressView.topAnchor.constraint(equalTo: targetStackView.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
