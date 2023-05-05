
//"http://api.openweathermap.org/data/2.5/weather?lat=46.8462427&lon=29.4673806&appid=622506d857f61426ac4243bf52e58da4"

import UIKit
//import RealmSwift

class MainViewController: UIViewController {
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Your name"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
        private lazy var addWorkoutButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = .specialYellow
            button.layer.cornerRadius = 10
            button.setTitle("Add workout", for: .normal)
            button.setImage(UIImage(named: "PlusImage"), for: .normal)
            button.tintColor = .specialDarkGreen
            button.titleLabel?.font = .robotoMedium12()
            button.addTarget(self, action: #selector(addWorkoutButtonTapped), for: .touchUpInside)
            button.imageEdgeInsets = .init(top: 0,
                                           left: 20,
                                           bottom: 15,
                                           right: 0)
            button.titleEdgeInsets = .init(top: 50,
                                           left: -40,
                                           bottom: 0,
                                           right: 0)
            button.addShadowOnView()
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    private let workoutTodayLabel = UILabel(text: "Workout Today")
    
    private let noWorkoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noWorkout")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let calendarView = CalendarView()
    private let weatherView = WeatherView()
    private let tableView = MainTableVIew()
    
    private var workoutArray = [WorkoutModel]()
    
    override func viewWillLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectItem(date: Date().localDate())
        setupUserParameters()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
        getWeather()
//        selectItem(date: Date().localDate())
        
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(calendarView)
        calendarView.setDelegate(self)
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(weatherView)
        view.addSubview(workoutTodayLabel)
        view.addSubview(tableView)
        tableView.mainDelegate = self
        view.addSubview(noWorkoutImageView)
    }

    @objc private func addWorkoutButtonTapped() {
        let newWorkoutViewController = NewWorkoutViewController()
        newWorkoutViewController.modalPresentationStyle = .fullScreen
        present(newWorkoutViewController, animated: true)
    }
    
    private func getWorkouts(date: Date) {
        let weekday = date.getWeekDayNumber()
        let dateStart = date.startAndDate().0
        let dateEnd = date.startAndDate().1
        
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateUnRepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [dateStart, dateEnd])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, predicateUnRepeat])
        
//        workoutArray = localRealm.objects(WorkoutModel.self).filter(compound).sorted(byKeyPath: "workoutName")
        let resultArray = RealmManager.shared.getResultWorkoutModel()
        let filtredArray = resultArray.filter(compound).sorted(byKeyPath: "workoutName")
        workoutArray = filtredArray.map{$0}
    }
    
    private func checkWorkoutToday() {
        if workoutArray.count == 0 {
            noWorkoutImageView.isHidden = false
            tableView.isHidden = true
        } else {
            noWorkoutImageView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func setupUserParameters() {
        
        let usserArray = RealmManager.shared.getResultUserModel()
        
        if usserArray.count != 0 {
            userNameLabel.text = usserArray[0].userFirstName + " " + usserArray[0].userSecondName
            
            guard let data = usserArray[0].userImage,
                  let image = UIImage(data: data) else {
                return
            }
            userPhotoImageView.image = image
        }
    }
    
    private func getWeather() {
        NetworkDataFetch.shared.fetchWeather { [weak self] result, error in
            guard let self = self else { return }
            
            
            if let model = result {
                print(model)
                self.weatherView.updateLabels(model: model)
                
                NetWorkImageRequest.shared.requestData(id: model.weather[0].icon) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                        
                    case .success(let data):
                        self.weatherView.updateImage(data: data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
//MARK: - CalendarViewProtocol

extension MainViewController: CalendarViewProtocol {
    func selectItem(date: Date) {
        getWorkouts(date: date)
//        var testArray = [WorkoutModel]()
//        workoutArray.forEach { model in
//            testArray.append(model)
//        }
        tableView.setWorkoutsArray(array: workoutArray)
        tableView.reloadData()
        checkWorkoutToday()
    }
}

//MARK: - MainTableViewProtocol
extension MainViewController: MainTableViewProtocol {
    func deleteWorkout(model: WorkoutModel, index: Int) {
        RealmManager.shared.daleteWorkoutModel(model)
        workoutArray.remove(at: index)
        tableView.setWorkoutsArray(array: workoutArray)
        tableView.reloadData()
    }
}

//MARK: - WorkoutCellProtocol
extension MainViewController: WorkoutCellProtocol {
    func staartButtonTapped(model: WorkoutModel) {
        if model.workoutTimer == 0 {
            let repsWorkoutViewController = RepsWorkoutViewController()
            repsWorkoutViewController.modalPresentationStyle = .fullScreen
            repsWorkoutViewController.setWorkoutModel(model)
            present(repsWorkoutViewController, animated: true)
        } else {
            let timerWorkoutViewController = TimerWorkoutViewController()
            timerWorkoutViewController.modalPresentationStyle = .fullScreen
            timerWorkoutViewController.setWorkoutModel(model)
            present(timerWorkoutViewController, animated: true)
        }
    }
}
//MARK: - SetConstraints

extension MainViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            calendarView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            
            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherView.heightAnchor.constraint(equalToConstant: 80),
            
            workoutTodayLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 10),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            tableView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            noWorkoutImageView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            noWorkoutImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            noWorkoutImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            noWorkoutImageView.heightAnchor.constraint(equalTo: noWorkoutImageView.widthAnchor, multiplier: 1)
        ])
    }
}
