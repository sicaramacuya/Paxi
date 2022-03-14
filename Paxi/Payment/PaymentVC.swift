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
    lazy var titleView: PaymentTitleView = {
        let view = PaymentTitleView(title: "New Payment", tintColor: vcTintColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    lazy var rentTicketView: PaymentRentTicketView = {
        let view = PaymentRentTicketView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundTicketNumber.backgroundColor = vcTintColor
        
        return view
    }()
    lazy var formView: PaymentFormView = {
        let view = PaymentFormView(viewController: self, tintColor: vcTintColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rentLabel.isHidden = true
        view.rentTextField.isHidden = true
        
        return view
    }()
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
        
        titleView.delegate = self
        
        // Adding to hierarchy
        self.view.addSubview(titleView)
        self.view.addSubview(rentTicketView)
        self.view.addSubview(formView)
        
        // Constraints
        NSLayoutConstraint.activate([
            // titleView
            titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 60),
            
            // ticketView
            rentTicketView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
            rentTicketView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            rentTicketView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            rentTicketView.heightAnchor.constraint(equalToConstant: 66),
            
            // formView
            formView.topAnchor.constraint(equalTo:
                                            rentTicketView.isHidden ? titleView.bottomAnchor : rentTicketView.bottomAnchor,
                                          constant: 20),
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
    
    func payRent() {
        let stack = CoreDataStack.shared
        
        guard let rentToPay = self.tenantSelected?.rentToPay else { return }
        
        rentToPay.payment = Double(self.formView.paymentTextField.text!)!
        
        // Storing it this way I assure it has the same time.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, y"
        rentToPay.datePayment = dateFormatter.date(from: self.formView.dateTextField.text!)!
        
        
        rentToPay.note = self.formView.noteTextField.text
        
        rentToPay.isRentPaid = true
        
        rentToPay.tenant!.createNextMonthRent(dateOfRentPayingNow: rentToPay.dateRentIsDue)
        
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
            guard let rent = unitSelected?.rent else { return }

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            let formattedNumber = numberFormatter.string(from: NSNumber(value:rent))
            
            self.rentTicketView.amountLabel.text = formattedNumber
            
            // Date Rent is Due
            guard let dueDate = unitSelected?.allTenants.first?.rentToPay.dateRentIsDue else { return } // NOT ALL THE TENANTS WILL START THE SAME DAY... REMEMBER THE RENT TO PAY DEPENDS ON WHEN THE TENANT HAS "MOVED IN".
            
            self.rentTicketView.dueDateLabel.text = dueDate.formatted(date: .long, time: .omitted)
            
            // Rent Ticket Number
            guard let ticketNumber = unitSelected?.allTenants.first?.ticketNumber else { return } // NOT ALL THE TENANTS WILL HAVE THE SAME AMOUNT OF PAYMENTS
            self.rentTicketView.ticketNumberLabel.text = String(ticketNumber)
            
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

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            let formattedNumber = numberFormatter.string(from: NSNumber(value:rent))
            
            self.rentTicketView.amountLabel.text = formattedNumber
            
            // Date Rent is Due
            guard let dueDate = tenantSelected?.rentToPay.dateRentIsDue else { return }
            self.rentTicketView.dueDateLabel.text = dueDate.formatted(date: .long, time: .omitted)
            
            // Rent Ticket Number
            guard let ticketNumber = tenantSelected?.ticketNumber else { return }
            self.rentTicketView.ticketNumberLabel.text = String(format: "%04d", ticketNumber)
            
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
        payRent()
        
        presentingViewController?.dismiss(animated: true)
    }
}
