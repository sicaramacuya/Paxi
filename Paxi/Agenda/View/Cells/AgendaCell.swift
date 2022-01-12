//
//  AgendaCell.swift
//  Paxi
//
//  Created by Eric Morales on 1/12/22.
//

import UIKit

class AgendaCell: UITableViewCell {
    
    // MARK: Properties
    static let identifier: String = "AgendaCell"
    lazy var horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill // direction of axis
        stack.alignment = .top // direction perpendiculat to the axis
        stack.spacing = 5
        
        return stack
    }()
    lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill // direction of axis
        stack.alignment = .leading // direction perpendiculat to the axis
        stack.spacing = 5
        
        return stack
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        //label.backgroundColor = .systemCyan
        
        return label
    }()
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    lazy var backgroundDueDateFlag: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        
        return view
    }()
    lazy var dueDateFlagLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        
        return label
    }()
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCell() {
        // Add view's heirachy
        self.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(verticalStack)
        verticalStack.addArrangedSubview(nameLabel)
        verticalStack.addArrangedSubview(amountLabel)
        horizontalStack.addArrangedSubview(backgroundDueDateFlag)
        backgroundDueDateFlag.addSubview(dueDateFlagLable)
        
        // Constraints
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            
            dueDateFlagLable.topAnchor.constraint(equalTo: backgroundDueDateFlag.topAnchor, constant: 5),
            dueDateFlagLable.bottomAnchor.constraint(equalTo: backgroundDueDateFlag.bottomAnchor, constant: -5),
            dueDateFlagLable.leadingAnchor.constraint(equalTo: backgroundDueDateFlag.leadingAnchor, constant: 5),
            dueDateFlagLable.trailingAnchor.constraint(equalTo: backgroundDueDateFlag.trailingAnchor, constant: -5)
        ])
    }
}
