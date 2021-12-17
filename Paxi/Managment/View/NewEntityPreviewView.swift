//
//  NewEntityPreviewView.swift
//  Paxi
//
//  Created by Eric Morales on 12/17/21.
//

import UIKit

class NewEntityPreviewView: UIView {
    
    // MARK: Properties
    lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        
        return view
    }()
    lazy var horizontalStackView: UIStackView = {
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
    lazy var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill // direction of axis
        stack.alignment = .trailing // direction perpendiculat to the axis
        stack.spacing = 5
        
        return stack
    }()
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textColor = .systemGray
        label.text = "$0.00"
        
        return label
    }()
    lazy var promptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 8, weight: .regular)
        label.textColor = .systemGray
        label.text = "Starting Balance"
        
        return label
    }()
    
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        
        titleLabel.text = title
    }
    
    
    // MARK: Methods
    func setup() {
        // MARK: Adding view to hierarchy
        self.addSubview(background)
        background.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(amountLabel)
        verticalStackView.addArrangedSubview(promptLabel)
        
        // MARK: Constraints
        let buffer: CGFloat = 20
        NSLayoutConstraint.activate([
            // background
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // stackView
            horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: buffer),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -buffer),
            horizontalStackView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: buffer),
            horizontalStackView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -buffer),
            horizontalStackView.centerYAnchor.constraint(equalTo: background.centerYAnchor),

        ])
        
    }
}
