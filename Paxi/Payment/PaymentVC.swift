//
//  PaymentVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

class PaymentVC: UIViewController {
    
    // MARK: Properties
    lazy var vcTintColor: UIColor = .systemGreen
    lazy var titleView = PaymentTitleView(title: "New Payment", tintColor: vcTintColor)
    lazy var formView = PaymentFormView(viewController: self, tintColor: vcTintColor)
    lazy var propertyPicker = UIPickerView()
    lazy var unitPicker = UIPickerView()
    lazy var tenantPicker = UIPickerView()
    lazy var propertyContent: [String] = ["Leguísamo", "Pitahaya", "Miradero"]
    lazy var unitContent: [String] = ["Unit #1", "Unit #2", "Unit #3"]
    lazy var tenantContent: [String] = ["Eric Morales", "Tommy Ellis"]
    
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setupViews()
        setupPickers()
    }
    
    
    // MARK: Methods
    func setupViews() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        formView.translatesAutoresizingMaskIntoConstraints = false
        
        // Adding to hierarchy
        self.view.addSubview(titleView)
        self.view.addSubview(formView)
        
        // Constraints
        NSLayoutConstraint.activate([
            // titleView
            titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            // formView
            formView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 50),
            formView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            formView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            formView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func setupPickers() {
        // property
        propertyPicker.dataSource = self
        propertyPicker.delegate = self
        formView.propertyTextField.inputView = propertyPicker
        
        // unit
        unitPicker.dataSource = self
        unitPicker.delegate = self
        formView.unitTextField.inputView = unitPicker
        
        // tenant
        tenantPicker.dataSource = self
        tenantPicker.delegate = self
        formView.tenantTextField.inputView = tenantPicker
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


// MARK: Picker Protocols
extension PaymentVC: UIPickerViewDataSource {
    // MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case propertyPicker:
            return propertyContent.count
        
        case unitPicker:
            return unitContent.count
        
        case tenantPicker:
            return tenantContent.count
        
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case propertyPicker:
            return propertyContent[row]
            
        case unitPicker:
            return unitContent[row]
            
        case tenantPicker:
            return tenantContent[row]
            
        default:
            return "?"
        }
    }
}

extension PaymentVC: UIPickerViewDelegate {
    // MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case propertyPicker:
            formView.propertyTextField.text = propertyContent[row]
            
        case unitPicker:
            formView.unitTextField.text = unitContent[row]
            
        case tenantPicker:
            formView.tenantTextField.text = tenantContent[row]
            
        default:
            break
        }
    }
}

