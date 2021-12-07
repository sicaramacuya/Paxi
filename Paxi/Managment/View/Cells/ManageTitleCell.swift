//
//  ManageTitleCell.swift
//  Paxi
//
//  Created by Eric Morales on 12/6/21.
//

import UIKit

class ManageTitleCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier: String = "ManageTitleCell"
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "TitleTextColor")
        label.text = "Manage"
        
        return label
    }()
    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(named: "TitleTextColor")
        
        return label
    }()
    lazy var plusImage:  UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "plus")
        
        return image
    }()
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.tintColor = .systemYellow
        button.addTarget(ManageVC(), action: #selector(ManageVC.addButtonSelected), for: .touchUpInside)
        
        return button
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
        subLabel.text = ""
    }
    
    func setup() {
        // adding it to view
        self.addSubview(mainLabel)
        self.addSubview(subLabel)
        self.addSubview(plusButton)
        plusButton.addSubview(plusImage)
        
        
        // constraints
        NSLayoutConstraint.activate([
            // mainLabel
            mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            mainLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            // subLabel
            subLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor),
            
            
            // plusButton
            plusButton.topAnchor.constraint(equalTo: self.topAnchor),
            plusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            plusButton.widthAnchor.constraint(equalToConstant: 50),
            plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor),
            
            // plusImage
            plusImage.widthAnchor.constraint(equalTo: plusButton.widthAnchor),
            plusImage.heightAnchor.constraint(equalTo: plusButton.heightAnchor),
        ])

    }
    
    func setContent(subTitle: String) {
        subLabel.text = subTitle
    }
}
