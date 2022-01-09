//
//  HistoryVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

class HistoryVC: UIViewController {
    
    // MARK: Properties
    lazy var vcTintColor: UIColor = .systemOrange
    lazy var buttonSize: CGSize = CGSize(width: 60, height: 60)
    lazy var addButton: UIButton = HistoryAddButtonView(buttonSize: buttonSize, vcTintColor: vcTintColor)
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setupPlusButton()
        setupNavigationController()
    }
    
    // MARK: Methods
    func setupNavigationController() {
        // add search button
        let searchButtonBarItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                        style: .plain, target: self, action: #selector(searchButtonSelected))
        
        self.navigationItem.rightBarButtonItem = searchButtonBarItem
        
        // style title
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let titleTextAttribute: [NSAttributedString.Key : Any] = [ .foregroundColor: UIColor.clear,]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute
        
        // add color
        self.navigationController?.navigationBar.tintColor = vcTintColor
    }
    
    func setupPlusButton() {
        self.view.addSubview(addButton)
        
        let buffer: CGFloat = 20
        addButton.frame = CGRect(x: self.view.frame.size.width - buttonSize.width - buffer,
                                 y: self.view.frame.size.height - buttonSize.height - buffer,
                                 width: buttonSize.width, height: buttonSize.height)
        
        addButton.addTarget(self, action: #selector(addButtonSelected), for: .touchUpInside)
    }
    
    @objc func addButtonSelected() {
        let alert = UIAlertController(title: "Add Something", message: "Add button has been tapped.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc func searchButtonSelected() {
        let alert = UIAlertController(title: "Search Something", message: "Search button has been tapped.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
}
