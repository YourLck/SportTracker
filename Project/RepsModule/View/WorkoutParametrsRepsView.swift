
import UIKit

protocol NextSetProtocol: AnyObject {
    func editingTapped()
    func nextSetTapped()
}

class WorkoutParametrsRepsView: UIView {
    
    private let workoutNameLabel = UILabel(text: "Biceps", font: .robotoMedium24(), textColor: .specialGray)
    
    private let setsLabel = UILabel(text: "Sets", font: .robotoMedium18(), textColor: .specialGray)
    
    private let numberOfSetsLabel = UILabel(text: "1/4", font: .robotoMedium18(), textColor: .specialGray)
    
    private let setsLineView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let repsLabel = UILabel(text: "Reps", font: .robotoMedium18(), textColor: .specialGray)
    
    private let numberOfRepsLabel = UILabel(text: "20", font: .robotoMedium18(), textColor: .specialGray)
    
    private let repsLineView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var  editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "editing")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Editing", for: .normal)
        button.tintColor = .specialLightBrown
        button.titleLabel?.font = .robotoMedium16()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var newSetsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT SET", for: .normal)
        button.tintColor = .specialGray
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextSetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var setsStackView = UIStackView()
    private var repsStackView = UIStackView()
    
    weak var cellNextSetDelegate: NextSetProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(workoutNameLabel)
        
        setsStackView = UIStackView(arrangedSubviews: [setsLabel, numberOfSetsLabel] , axis: .horizontal, spacing: 10)
        setsStackView.distribution = .equalCentering
        addSubview(setsStackView)
        addSubview(setsLineView)
        
        repsStackView = UIStackView(arrangedSubviews: [repsLabel, numberOfRepsLabel], axis: .horizontal, spacing: 10)
        repsStackView.distribution = .equalCentering
        addSubview(repsStackView)
        addSubview(repsLineView)
        
        addSubview(editingButton)
        addSubview(newSetsButton)
    }
    
    @objc private func editingButtonTapped() {
        cellNextSetDelegate?.editingTapped()
    }
    
    @objc private func nextSetButtonTapped() {
        cellNextSetDelegate?.nextSetTapped()
    }
    
    public func refreshLabels(model: WorkoutModel, numberOfSet: Int) {
        workoutNameLabel.text = model.workoutName
        numberOfSetsLabel.text = "\(numberOfSet)/\(model.workoutSets)"
        numberOfRepsLabel.text = "\(model.workoutReps)"
    }
}
// MARK: - SetConstraints

extension WorkoutParametrsRepsView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            workoutNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            workoutNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            setsStackView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 20),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            setsLineView.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 2),
            setsLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            setsLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            setsLineView.heightAnchor.constraint(equalToConstant: 1),
            
            repsStackView.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 30),
            repsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            repsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            repsLineView.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 2),
            repsLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            repsLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            repsLineView.heightAnchor.constraint(equalToConstant: 1),
            
            editingButton.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 10),
            editingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            newSetsButton.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 40),
            newSetsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            newSetsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            newSetsButton.heightAnchor.constraint(equalToConstant: 45),
            newSetsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
