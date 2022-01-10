//
//  CalendarCell.swift
//  Paxi
//
//  Created by Eric Morales on 1/10/22.
//

import UIKit

class CalendarCell: UITableViewCell {
    
    // MARK: Properties
    static let identifier: String = "HistoryCalendarCell"
    lazy var horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill // direction of axis
        stack.alignment = .center // direction perpendiculat to the axis
        stack.spacing = 5
        //stack.backgroundColor = .systemYellow
        
        return stack
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        //label.backgroundColor = .systemCyan
        
        return label
    }()
    lazy var paymentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        //label.backgroundColor = .systemGreen
        
        return label
    }()
    lazy var arrowLogo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "chevron.right")
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemGray
        //image.backgroundColor = .systemRed
        
        
        return image
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
        horizontalStack.addArrangedSubview(nameLabel)
        horizontalStack.addArrangedSubview(paymentLabel)
        self.addSubview(arrowLogo)
        
        // Constraints
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: arrowLogo.leadingAnchor, constant: -10),
            
            arrowLogo.leadingAnchor.constraint(equalTo: horizontalStack.trailingAnchor),
            arrowLogo.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            arrowLogo.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor),
            
            
            arrowLogo.heightAnchor.constraint(equalTo: paymentLabel.heightAnchor),
            arrowLogo.widthAnchor.constraint(equalTo: arrowLogo.heightAnchor),
            
        ])
    }
    
}
