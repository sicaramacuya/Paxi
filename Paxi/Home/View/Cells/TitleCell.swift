//
//  TitleCell.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

class TitleCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier: String = "TitleCell"
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "TitleTextColor")
        
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
    
    
    // MARK: Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    func reset() {
        // add here any cleanup needed.
        label.text = ""
    }
    
    func setup() {
        // adding it to view
        self.addSubview(label)
        
        // constraints
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
    }
    
    func setContent(title: String) {
        label.text = title
    }
}
