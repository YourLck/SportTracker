
import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    private let nameLabel = UILabel(text: "Push Ups", font: .robotoBold24(), textColor: .white)
    
    private let workoutImageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.image = UIImage(named: "imageCell")?.withRenderingMode(.alwaysTemplate)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let numberLabel = UILabel(text: "180", font: .robotoBold24(), textColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialDarkYellow
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(nameLabel)
        addSubview(workoutImageView)
        addSubview(numberLabel)
    }
    
    public func cellConfigure(model: ResultWorkout) {
        nameLabel.text = model.name
        numberLabel.text = "\(model.result)"
        
        guard let data = model.imageData else {return}
        let image = UIImage(data: data)
        workoutImageView.image = image
    }
}
//MARK: - SetConstraints

extension ProfileCollectionViewCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            workoutImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            workoutImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            workoutImageView.heightAnchor.constraint(equalToConstant: 57),
            workoutImageView.widthAnchor.constraint(equalToConstant: 57),

            numberLabel.centerYAnchor.constraint(equalTo: workoutImageView.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: workoutImageView.trailingAnchor, constant: 20)
        ])
    }
}
