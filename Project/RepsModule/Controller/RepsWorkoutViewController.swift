
import UIKit

class RepsWorkoutViewController: UIViewController {
    
    private let strartWorkoutLabelReps = UILabel(text: "START WORKOUT", font: .robotoBold24(), textColor: .specialGray)
    
    private let details = UILabel(text: "Details")
    
    private let startWorkoutImageReps: UIImageView = {
        let startWorkout = UIImageView()
        startWorkout.image = UIImage(named: "StartWorkoutImage")
        startWorkout.contentMode = .scaleAspectFit
        startWorkout.translatesAutoresizingMaskIntoConstraints = false
        return startWorkout
    }()
    
    private lazy var closeButton = CloseButton(type: .system)
    
    private lazy var finishButton = GreenButton(text: "FINISH")
    
    private let workoutParametrsRepsView = WorkoutParametrsRepsView()
    
    private var workoutModel = WorkoutModel()
    private var numberOfSet = 1
    
    private let customAlert = CustomAlert()
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(strartWorkoutLabelReps)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        view.addSubview(finishButton)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        
        view.addSubview(startWorkoutImageReps)
        view.addSubview(details)
        workoutParametrsRepsView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        view.addSubview(workoutParametrsRepsView)
        view.addSubview(finishButton)
    }
    
    private func setDelegates() {
        workoutParametrsRepsView.cellNextSetDelegate = self
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel)
        } else {
            presentAlertWithActions(title: "Warning", massage: "You haven't finished your workout") {
                self.dismiss(animated: true)
            }
        }
    }
    
    public func setWorkoutModel(_ model: WorkoutModel) {
        workoutModel = model
    }
}
// MARK: - NextSetProtocol

extension RepsWorkoutViewController: NextSetProtocol {
    
    func editingTapped() {
        customAlert.presentCustomAlert(viewController: self, repsOrTimer: "Reps") { [weak self] sets, reps in
            guard let self = self else { return }
            if sets != "" && reps != "" {
                guard let numberOfSets = Int(sets),
                      let numberOfReps = Int(reps) else { return }
                RealmManager.shared.updateSetsRepsWorkoutModel(model: self.workoutModel,
                                                               sets: numberOfSets,
                                                               reps: numberOfReps)
                self.workoutParametrsRepsView.refreshLabels(model: self.workoutModel, numberOfSet: self.numberOfSet)
            }
        }
    }
    
    func nextSetTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            workoutParametrsRepsView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        } else {
            presentSimpleAlert(title: "Error", massage: "Finish your workout")
        }
    }
}
// MARK: - SetConstraints
extension RepsWorkoutViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            strartWorkoutLabelReps.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            strartWorkoutLabelReps.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        
            closeButton.centerYAnchor.constraint(equalTo: strartWorkoutLabelReps.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            
            startWorkoutImageReps.topAnchor.constraint(equalTo: strartWorkoutLabelReps.bottomAnchor, constant: 30),
            startWorkoutImageReps.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startWorkoutImageReps.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            startWorkoutImageReps.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            details.topAnchor.constraint(equalTo: startWorkoutImageReps.bottomAnchor, constant: 30),
            details.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            details.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            workoutParametrsRepsView.topAnchor.constraint(equalTo: details.bottomAnchor, constant: 3),
            workoutParametrsRepsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workoutParametrsRepsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            workoutParametrsRepsView.heightAnchor.constraint(equalToConstant: 230),
            
            finishButton.topAnchor.constraint(equalTo: workoutParametrsRepsView.bottomAnchor, constant: 20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
