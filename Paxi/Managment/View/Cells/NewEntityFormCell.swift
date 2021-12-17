//
//  NewEntityFormCell.swift
//  Paxi
//
//  Created by Eric Morales on 12/17/21.
//

import UIKit

class NewEntityFormCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier: String = "NewEntityFormCell"
    lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        
        return view
    }()
    lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill // direction of axis
        stack.alignment = .leading // direction perpendiculat to the axis
        
        return stack
    }()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.tintColor = .systemYellow
        textField.borderStyle = .none

        return textField
    }()
    lazy var bottomLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .systemYellow
        
        return line
    }()

    
    // MARK: Initializer
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
    }
    
    func setup() {
        // MARK: Adding view to hierarchy
        //self.addSubview(background)
        //background.addSubview(horizontalStackView)
        //horizontalStackView.addArrangedSubview(textField)
        
        self.addSubview(textField)
        self.addSubview(bottomLine)

        
        // MARK: Constraints
        //let buffer: CGFloat = 0
        NSLayoutConstraint.activate([
            // textField
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomLine.topAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            // bottomLine
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 2),
            bottomLine.widthAnchor.constraint(equalTo: textField.widthAnchor)

        ])
    }
    
    func setContent(title: String) {
        // set any content withing the cell
        textField.placeholder = title
    }
}
