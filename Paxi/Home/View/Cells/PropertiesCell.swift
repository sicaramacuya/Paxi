//
//  PropertiesCell.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

class PropertiesCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier: String = "PropertiesCell"
    lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        
        return view
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill // direction of axis
        stack.alignment = .fill // direction perpendiculat to the axis
        stack.spacing = 5
        
        return stack
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "building.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemIndigo
        
        return imageView
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemGray
        
        return label
    }()
    lazy var arrowLogo: UIImageView = {
        let arrowLogo = UIImageView()
        arrowLogo.translatesAutoresizingMaskIntoConstraints = false
        arrowLogo.image = UIImage(systemName: "chevron.right")
        arrowLogo.contentMode = .scaleAspectFit
        arrowLogo.tintColor = .systemGray
        
        return arrowLogo
    }()
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    func reset() {
        // add here any cleanup needed.
        self.label.text = ""
    }
    
    func setup() {
        // MARK: Adding view to hierarchy
        self.addSubview(background)
        background.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(arrowLogo)
        
        // MARK: Constraints
        let buffer: CGFloat = 5
        NSLayoutConstraint.activate([
            // background
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // stackView
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: buffer),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -buffer),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: buffer),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: (-buffer - 10)),
            
            // imageView
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            // arrowLogo
            arrowLogo.widthAnchor.constraint(equalToConstant: 15),
            arrowLogo.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
    }
    
    func setContent(property: Property) {
        self.label.text = property.title
    }
}
