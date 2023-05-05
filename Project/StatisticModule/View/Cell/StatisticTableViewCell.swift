
import UIKit

class StatisticViewCell: UITableViewCell {
    
    private let exerciseName = UILabel(text: "Push Ups", font: .robotoMedium22(), textColor: .specialBlack)
    
    private let beforeLabel = UILabel(text: "Before: 16")

    private let nowLabel = UILabel(text: "Now: 20")

    private let differenceLabel = UILabel(text: "+2", font: .robotoMedium24(), textColor: .specialGreen)

    var statisticStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(exerciseName)
        addSubview(differenceLabel)
        
        statisticStackView = UIStackView(arrangedSubviews: [beforeLabel, nowLabel], axis: .horizontal, spacing: 10)
        
        addSubview(statisticStackView)
    }
    
    public func configure(differenceWorkout: DifferenceWorkout) {
        exerciseName.text = differenceWorkout.name
        beforeLabel.text = "Before: \(differenceWorkout.firstReps)"
        nowLabel.text = "Now: \(differenceWorkout.lastReps)"
        
        
        let difference = differenceWorkout.lastReps - differenceWorkout.firstReps
        differenceLabel.text = "\(difference)"
        
        switch difference {
        case ..<0: differenceLabel.textColor = .specialGreen
        case 1...: differenceLabel.textColor = .specialYellow
        default: differenceLabel.textColor = .specialGray
        }
    }
}
//MARK: - SetConstraints

extension StatisticViewCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            differenceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            differenceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            differenceLabel.widthAnchor.constraint(equalToConstant: 50),
                    
            exerciseName.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            exerciseName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            exerciseName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            statisticStackView.topAnchor.constraint(equalTo: exerciseName.bottomAnchor, constant: 0),
            statisticStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
}
