
import UIKit

protocol WorkoutCellProtocol: AnyObject {
    func staartButtonTapped(model: WorkoutModel)
}

class WorkoutTableViewCell: UITableViewCell {
    
    private let backgroundCell: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .specialBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let workoutBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .specialBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let wourkoutImageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.image = UIImage(named: "imageCell")?.withRenderingMode(.alwaysTemplate)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let workoutNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .specialBlack
        label.font = .robotoMedium22()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutRepsLabel: UILabel = {
       let label = UILabel()
        label.textColor = .specialGray
        label.font = .robotoMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutSetsLabel: UILabel = {
       let label = UILabel()
        label.textColor = .specialGray
        label.font = .robotoMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
 
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.addShadowOnView()
        button.titleLabel?.font = .robotoBold16()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var labelStackView = UIStackView()
    
    weak var workoutCellDelegate: WorkoutCellProtocol?
    
    private var workoutModel = WorkoutModel()
    
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
        
        addSubview(backgroundCell)
        addSubview(workoutBackgroundView)
        workoutBackgroundView.addSubview(wourkoutImageView)
        addSubview(workoutNameLabel)
        
        labelStackView = UIStackView(arrangedSubviews: [workoutSetsLabel, workoutRepsLabel], axis: .horizontal, spacing: 10)
        
        addSubview(labelStackView)
        contentView.addSubview(startButton)
    }
    
    @objc private func startButtonTapped() {
        workoutCellDelegate?.staartButtonTapped(model: workoutModel)
        print("startButtonTapped")
    }
    
    public func configure(model: WorkoutModel) {
        
        workoutModel = model
        
        workoutNameLabel.text = model.workoutName
        
        if model.workoutTimer == 0 {
            workoutRepsLabel.text = "Reps: \(model.workoutReps)"
        } else {
            workoutRepsLabel.text = "Timer: \(model.workoutTimer.getTimeFromSeconds())"
        }

        workoutSetsLabel.text = "Sets: \(model.workoutSets)"
        

        if model.workoutStatus {
            startButton.setTitle("COMPLETE", for: .normal)
            startButton.tintColor = .white
            startButton.backgroundColor = .specialGreen
            startButton.isEnabled = false
        } else {
            startButton.setTitle("START", for: .normal)
            startButton.tintColor = .specialGreen
            startButton.backgroundColor = .specialYellow
            startButton.isEnabled = true
        }
        
        guard let imageData = model.workoutImage,
              let image = UIImage(data: imageData) else { return }
        wourkoutImageView.image = image.withRenderingMode(.alwaysTemplate)
    }
}
// MARK: - setConstraints

extension WorkoutTableViewCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            workoutBackgroundView.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            workoutBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            workoutBackgroundView.heightAnchor.constraint(equalToConstant: 80),
            workoutBackgroundView.widthAnchor.constraint(equalToConstant: 80),
            
            wourkoutImageView.topAnchor.constraint(equalTo: workoutBackgroundView.topAnchor, constant: 10),
            wourkoutImageView.leadingAnchor.constraint(equalTo: workoutBackgroundView.leadingAnchor, constant: 10),
            wourkoutImageView.trailingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: -10),
            wourkoutImageView.bottomAnchor.constraint(equalTo: workoutBackgroundView.bottomAnchor, constant: -10),
            
            workoutNameLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 10),
            workoutNameLabel.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 100),
            workoutNameLabel.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            
            labelStackView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 0),
            labelStackView.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            labelStackView.heightAnchor.constraint(equalToConstant: 20),
            
            startButton.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 5),
            startButton.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            startButton.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            startButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
