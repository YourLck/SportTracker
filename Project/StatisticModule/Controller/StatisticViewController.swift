
import UIKit

class StatisticViewController: UIViewController {
    
    private let statisticLabel = UILabel(text: "STATISTIC")
    
    private let exercisesLabel = UILabel(text: "Exercises")
    
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Week","Month"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialGreen
        segmentedControl.selectedSegmentTintColor = .specialYellow
        let font = UIFont(name: "Roboto-Medium", size: 16)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor : UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor : UIColor.specialGray], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let nameTextField = BrownTextField()
    
    private let tableView = StatisticTableView()
    
    private var workoutArray = [WorkoutModel]()
    private var differenceArray = [DifferenceWorkout]()
    private var filteredArray = [DifferenceWorkout]()
    
    private var isFiltered = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        differenceArray = [DifferenceWorkout]()
        setStartScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setStartScreen()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(statisticLabel)
        view.addSubview(segmentedControl)
        nameTextField.brownDelegate = self
        view.addSubview(nameTextField)
        view.addSubview(exercisesLabel)
        view.addSubview(tableView)
    }
    
    
    @objc private func segmentedChange() {
        
        let dateToday = Date().localDate()
        differenceArray = [DifferenceWorkout]()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let dateStart = dateToday.offsetDay(day: 7)
            getDifferenceModel(dateStart: dateStart)
        } else {
            let dateStart = dateToday.offsetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
        }
        tableView.reloadData()
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
    
    private func getDifferenceModel(dateStart: Date) {
        let dateEnd = Date().localDate()
        let nameArray = getWorkoutsName()
        let allWorkouts = RealmManager.shared.getResultWorkoutModel()
        
        for name in nameArray {
            let predicateDifference = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@",
                [dateStart, dateEnd])
            
            let filteredArray = allWorkouts.filter(predicateDifference).sorted(byKeyPath: "workoutDate")
            workoutArray = filteredArray.map{$0}
            
            guard let last = workoutArray.last?.workoutReps,
                  let first = workoutArray.first?.workoutReps else {
                return
            }
            let differenceWorkout = DifferenceWorkout(name: name, lastReps: last, firstReps: first)
            differenceArray.append(differenceWorkout)
        }
        tableView.setDifferenceArray(array: differenceArray)
    }
    
    private func setStartScreen() {
        let dateToday = Date().localDate()
        getDifferenceModel(dateStart: dateToday.offsetDay(day: 7))
        tableView.reloadData()
    }
    
    private func filteredWorkouts(text: String) {
        
        for workout in differenceArray {
            if workout.name.lowercased().contains(text.lowercased()) {
                filteredArray.append(workout)
            }
        }
    }
}
//MARK: - BrownTextFieldProtocol

extension StatisticViewController: BrownTextFieldProtocol {
    
    func typing(range: NSRange, replacementString: String) {
        if let text = nameTextField.text,
           let textRange = Range(range, in: text) {
            let updateText = text.replacingCharacters(in: textRange, with: replacementString)
            filteredArray = [DifferenceWorkout]()
            isFiltered = updateText.count > 0
            filteredWorkouts(text: updateText)
}
        
        if isFiltered {
            tableView.setDifferenceArray(array: filteredArray)
        } else {
            tableView.setDifferenceArray(array: differenceArray)
        }
        tableView.reloadData()
    }
    
    func clear() {
        isFiltered = false
        differenceArray = [DifferenceWorkout]()
        let dateToday = Date().localDate()
        getDifferenceModel(dateStart: dateToday.offsetDay(day: 7))
        tableView.reloadData()
    }
}
//MARK: - setConstraints

extension StatisticViewController {

    private func setConstraints() {
        NSLayoutConstraint.activate([
            statisticLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            statisticLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticLabel.heightAnchor.constraint(equalToConstant: 24),
            
            segmentedControl.topAnchor.constraint(equalTo: statisticLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            exercisesLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
