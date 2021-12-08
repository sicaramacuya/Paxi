//
//  NewEntityTitleCell.swift
//  Paxi
//
//  Created by Eric Morales on 12/7/21.
//

import UIKit

class NewEntityTitleCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier: String = "NewEntityTitleCell"
    lazy var cancelImage:  UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "xmark")
        
        return image
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.tintColor = .systemYellow
        button.addTarget(NewEntityVC(), action: #selector(NewEntityVC.cancelButtonSelected), for: .touchUpInside)
        
        return button
    }()
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.textColor = UIColor(named: "TitleTextColor")
        label.textAlignment = .center
        
        return label
    }()
    lazy var checkMarkImage:  UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "checkmark")
        
        return image
    }()
    lazy var checkMarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.tintColor = .systemYellow
        button.addTarget(NewEntityVC(), action: #selector(NewEntityVC.checkMarkButtonSelected), for: .touchUpInside)
        
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
    }
    
    func setup() {
        // adding it to view
        self.addSubview(mainLabel)
        self.addSubview(cancelButton)
        cancelButton.addSubview(cancelImage)
        self.addSubview(checkMarkButton)
        checkMarkButton.addSubview(checkMarkImage)
        
        
        // constraints
        NSLayoutConstraint.activate([
            // mainLabel
            mainLabel.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: checkMarkButton.leadingAnchor),
            mainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            
            // cancelButton
            cancelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 40),
            cancelButton.heightAnchor.constraint(equalTo: checkMarkButton.widthAnchor),
            
            // cancelImage
            cancelImage.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            cancelImage.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            
            // checkMarkButton
            checkMarkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            checkMarkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            checkMarkButton.widthAnchor.constraint(equalToConstant: 40),
            checkMarkButton.heightAnchor.constraint(equalTo: checkMarkButton.widthAnchor),
            
            // checkMarkImage
            checkMarkImage.widthAnchor.constraint(equalTo: checkMarkButton.widthAnchor),
            checkMarkImage.heightAnchor.constraint(equalTo: checkMarkButton.heightAnchor),
        ])

    }
    
    func setContent(title: String) {
        // set any content withing the cell
        self.mainLabel.text = title
    }
}
