//
//  ManageEntityCell.swift
//  Paxi
//
//  Created by Eric Morales on 12/6/21.
//

import UIKit

class ManageEntityCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier: String = "ManageEntityCell"
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
        stack.alignment = .leading // direction perpendiculat to the axis
        stack.spacing = 5
        
        return stack
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .systemGray
        
        return label
    }()
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textColor = .systemGray
        
        return label
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
        self.titleLabel.text = ""
        self.amountLabel.text = ""
    }
    
    func setup() {
        // MARK: Adding view to hierarchy
        self.addSubview(background)
        background.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(amountLabel)
        
        // MARK: Constraints
        let buffer: CGFloat = 20
        NSLayoutConstraint.activate([
            // background
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // stackView
            stackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: buffer),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -buffer),
        ])
        
    }
    
    func setContent(title: String, amount: Double) {
        self.titleLabel.text = title
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:amount))
        self.amountLabel.text = "$\(formattedNumber!)"
    }
}
