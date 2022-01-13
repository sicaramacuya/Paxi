//
//  PaymentRentTicketView.swift
//  Paxi
//
//  Created by Eric Morales on 1/13/22.
//

import UIKit

class PaymentRentTicketView: UIView {
    
    // MARK: Properties
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
    lazy var dueDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "Due date"
        
        return label
    }()
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "$0.00"
        
        return label
    }()
    lazy var backgroundTicketNumber: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.cornerRadius = 3
        background.layer.masksToBounds = true
        
        return background
    }()
    lazy var ticketNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.text = "0000"
        
        return label
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func setup() {
        // Add view's heirachy
        self.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(verticalStack)
        verticalStack.addArrangedSubview(dueDateLabel)
        verticalStack.addArrangedSubview(amountLabel)
        horizontalStack.addArrangedSubview(backgroundTicketNumber)
        backgroundTicketNumber.addSubview(ticketNumberLabel)
        
        // Constraints
        let buffer: CGFloat =  5
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            
            ticketNumberLabel.topAnchor.constraint(equalTo: backgroundTicketNumber.topAnchor, constant: buffer),
            ticketNumberLabel.bottomAnchor.constraint(equalTo: backgroundTicketNumber.bottomAnchor, constant: -buffer),
            ticketNumberLabel.leadingAnchor.constraint(equalTo: backgroundTicketNumber.leadingAnchor, constant: buffer),
            ticketNumberLabel.trailingAnchor.constraint(equalTo: backgroundTicketNumber.trailingAnchor, constant: -buffer)
        ])
    }
}
