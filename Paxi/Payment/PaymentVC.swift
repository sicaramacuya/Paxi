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
    var propertyContent: [Property] = []
    var unitContent: [Unit] = []
    var tenantContent: [Tenant] = []
    var propertySelected: Property?
    var unitSelected: Unit?
    var tenantSelected: Tenant?
    
    
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
        
        titleView.delegate = self
        
        // Adding to hierarchy
        self.view.addSubview(titleView)
        self.view.addSubview(formView)
        
        // Constraints
        NSLayoutConstraint.activate([
            // titleView
            titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 60),
            
            // formView
            formView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
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
    
    func savePayment() {
        let stack = CoreDataStack.shared
        let context = stack.persistentContainer.viewContext
        
        let payment = Payment(context: context)
        payment.property = self.propertySelected
        payment.unit = self.unitSelected
        payment.tenant = self.tenantSelected
        payment.rent = Double(self.formView.rentTextField.text!)!
        payment.payment = Double(self.formView.paymentTextField.text!)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, y"
        payment.datePayment = dateFormatter.date(from: self.formView.dateTextField.text!)!
        
        payment.note = self.formView.noteTextField.text
        
        stack.saveContext()
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
            return propertyContent[row].title!
            
        case unitPicker:
            return unitContent[row].title!
            
        case tenantPicker:
            return tenantContent[row].name!
            
        default:
            return "?"
        }
    }
}

extension PaymentVC: UIPickerViewDelegate {
    // MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        manageSelectionOfPickerRows(pickerView: pickerView, didSelectRow: row)
    }
    
    func manageSelectionOfPickerRows(pickerView: UIPickerView, didSelectRow row: Int) {
        switch pickerView {
        case propertyPicker:
            self.propertySelected = propertyContent[row]
            self.formView.propertyTextField.text = propertySelected!.title
            
            
            // Unit
            let property = propertyContent[row]
            self.unitContent = property.allUnits
            
            // Tenant
            self.tenantContent = property.allTenants
            
        case unitPicker:
            self.unitSelected = unitContent[row]
            self.formView.unitTextField.text = unitSelected!.title
            
            // Property
            self.propertySelected = unitSelected!.property!
            self.propertyContent = [propertySelected!]
            self.formView.propertyTextField.text = unitSelected!.property!.title
            
            // Tenant
            self.tenantContent = unitSelected!.allTenants
            
            // Rent
            self.formView.rentTextField.text = String(unitSelected!.rent)
            
        case tenantPicker:
            self.tenantSelected = tenantContent[row]
            self.formView.tenantTextField.text = tenantSelected!.name!
            
            // Property
            self.propertySelected = tenantSelected!.property!
            self.propertyContent = [propertySelected!]
            formView.propertyTextField.text = propertySelected!.title
            
            // Unit
            self.unitSelected = tenantSelected!.unit!
            self.unitContent = [unitSelected!]
            self.formView.unitTextField.text = unitSelected!.title
            
            // Rent
            guard let rent = unitSelected?.rent else { return }
            formView.rentTextField.text = String(rent)
            
        default:
            break
        }
    }
}

// MARK: Buttons Protocol
extension PaymentVC: ButtonSelectionDelegate {
    // MARK: ButtonSelectionDelegate
    func buttonSelected(cancelButton: UIButton) {
        
        presentingViewController?.dismiss(animated: true)
    }
    
    func buttonSelected(checkMarkButton: UIButton) {
        savePayment()
        
        presentingViewController?.dismiss(animated: true)
    }
}
