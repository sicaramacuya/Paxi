//
//  PaymentVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

class PaymentVC: UIViewController {
    
    // MARK: Properties
    lazy var titleView = PaymentTitleView(title: "New Payment")
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setup()
    }
    
    
    // MARK: Methods
    func setup() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    @objc func cancelButtonSelected() {
        print("Cancel button selected! [PaymentVC]")
        
        presentingViewController?.dismiss(animated: true)
    }
    
    @objc func checkMarkButtonSelected() {
        print("Checkmark button selected!")
        
        presentingViewController?.dismiss(animated: true)
    }
}
