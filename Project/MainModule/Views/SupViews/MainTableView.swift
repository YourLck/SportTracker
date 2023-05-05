
import UIKit

protocol MainTableViewProtocol: AnyObject {
    func deleteWorkout(model: WorkoutModel, index: Int)
}

class MainTableVIew: UITableView {
    
    weak var mainDelegate: (MainTableViewProtocol)?
    
    private let idTableViewCell = "idTableViewCell"
    
    private var workoutsArray = [WorkoutModel]()
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        setDelegates()
        register(WorkoutTableViewCell.self, forCellReuseIdentifier: idTableViewCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .none
        separatorStyle = .none
        bounces = false
        showsVerticalScrollIndicator = false
        delaysContentTouches = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setDelegates() {
        delegate = self
        dataSource = self
    }
    
    public func setWorkoutsArray(array: [WorkoutModel]) {
        workoutsArray = array
    }
}
//MARK: - UITableViewDataSource

extension MainTableVIew: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idTableViewCell, for: indexPath) as? WorkoutTableViewCell else {
            return UITableViewCell()
        }
        let workoutModel = workoutsArray[indexPath.row]
        cell.configure(model: workoutModel)
        cell.workoutCellDelegate = mainDelegate as? WorkoutCellProtocol
        return cell
    }
}
//MARK: - UITableViewDelegate

extension MainTableVIew: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "") { _, _, _ in
            let deleteModel = self.workoutsArray[indexPath.row]
            self.mainDelegate?.deleteWorkout(model: deleteModel, index: indexPath.row)
        }
        
        action.backgroundColor = .specialBackground
        action.image = UIImage(named: "delete")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
