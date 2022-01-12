//
//  AgendaVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

class AgendaVC: UIViewController {
    
    // MARK: Properties
    lazy var vcTintColor: UIColor = .systemPurple
    
    // MARK: VC's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        self.title = "Agenda"
        
        
        setupNavigationController()
    }
    
    
    // MARK: Methods
    func setupNavigationController() {
        // style title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let titleTextAttribute: [NSAttributedString.Key : Any] = [ .foregroundColor: UIColor.clear,]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute
        
        // add color
        self.navigationController?.navigationBar.tintColor = vcTintColor
    }
}
