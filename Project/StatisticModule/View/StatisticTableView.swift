
import UIKit

class StatisticTableView: UITableView {
    
    private let idTableViewStat = "idTableViewStat"
    
    private var differenceArray = [DifferenceWorkout]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        setDelegates()
        register(StatisticViewCell.self, forCellReuseIdentifier: idTableViewStat)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .none
        separatorStyle = .none
        bounces = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setDelegates() {
        dataSource = self
        delegate = self
    }
    
    public func setDifferenceArray(array: [DifferenceWorkout]) {
        differenceArray = array
    }
}
// MARK: - StatisticTableView
    
    extension StatisticTableView: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            differenceArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: idTableViewStat,
                                                           for: indexPath) as? StatisticViewCell else {
                return UITableViewCell()
            }
            let model = differenceArray[indexPath.row]
            cell.configure(differenceWorkout: model)
            return cell
        }
    }
    
    extension  StatisticTableView: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            55
        }
    }
