//
//  PaymentFormView.swift
//  Paxi
//
//  Created by Eric Morales on 1/6/22.
//

import UIKit

class PaymentFormView: UIView {

    // MARK: Properties
    var formTintColor: UIColor = UIColor()
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        return scroll
    }()
    lazy var formStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill // direction of axis
        stack.alignment = .fill // perpendicular to axis
        stack.spacing = 15
        
        return stack
    }()
    lazy var propertyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.tintColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Property"
        
        return label
    }()
    lazy var propertyTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ""
        textField.keyboardType = .default
        textField.tintColor = formTintColor

        return textField
    }()
    lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.tintColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Unit"
        
        return label
    }()
    lazy var unitTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ""
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.tintColor = formTintColor

        return textField
    }()
    lazy var tenantLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.tintColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Tenant"
        
        return label
    }()
    lazy var tenantTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ""
        textField.keyboardType = .default
        textField.tintColor = formTintColor

        return textField
    }()
    lazy var rentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.tintColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Rent"
        
        return label
    }()
    lazy var rentTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ""
        textField.keyboardType = .decimalPad
        textField.tintColor = formTintColor

        return textField
    }()
    lazy var paymentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.tintColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Payment"
        
        return label
    }()
    lazy var paymentTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ""
        textField.keyboardType = .decimalPad
        textField.tintColor = formTintColor

        return textField
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.tintColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Date"
        
        return label
    }()
    lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ""
        textField.inputView = self.datePicker
        textField.tintColor = formTintColor

        return textField
    }()
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        
        return dateFormatter
    }()
    lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.tintColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Note"
        
        return label
    }()
    lazy var noteTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = ""
        textField.keyboardType = .default
        textField.tintColor = formTintColor

        return textField
    }()
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewController: UIViewController, tintColor: UIColor) {
        self.init()
        
        self.formTintColor = tintColor
        self.setup(viewController: viewController)
    }
    
    // MARK: Methods
    func setup(viewController: UIViewController) {
        // MARK: View's hirerachy
        self.addSubview(scrollView)
        scrollView.addSubview(formStack)
        formStack.addArrangedSubview(propertyLabel)
        formStack.addArrangedSubview(propertyTextField)
        formStack.addArrangedSubview(unitLabel)
        formStack.addArrangedSubview(unitTextField)
        formStack.addArrangedSubview(tenantLabel)
        formStack.addArrangedSubview(tenantTextField)
        formStack.addArrangedSubview(rentLabel)
        formStack.addArrangedSubview(rentTextField)
        formStack.addArrangedSubview(paymentLabel)
        formStack.addArrangedSubview(paymentTextField)
        formStack.addArrangedSubview(dateLabel)
        formStack.addArrangedSubview(dateTextField)
        formStack.addArrangedSubview(noteLabel)
        formStack.addArrangedSubview(noteTextField)
        
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            // formStack
            formStack.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
            formStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            formStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
        
        // MARK: Gesture Recognizer
        viewController.view.addGestureRecognizer(tapGesture)
        
        // MARK: Adding Bottom Line To TextField
        self.setUpTextFieldsBorders()
    }
    
    func setUpTextFieldsBorders() {
        let textFields = [tenantTextField, propertyTextField, unitTextField, rentTextField, paymentTextField, dateTextField, noteTextField]
        
        for textField in textFields {
            textField.addLine(position: .bottom, color: formTintColor, width: 1)
        }
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {

        // dismiss keyboard for weight text field
        if tenantTextField.isEditing {
            
            tenantTextField.resignFirstResponder()
        }
        
        // dismiss keyboard for property text field
        if propertyTextField.isEditing {
            
            propertyTextField.resignFirstResponder()
        }
        
        // dismiss keyboard for unit text field
        if unitTextField.isEditing {
            
            unitTextField.resignFirstResponder()
        }
        
        // dismiss keyboard for rent text field
        if rentTextField.isEditing {
            
            rentTextField.resignFirstResponder()
        }
        
        // dismiss keyboard for payment text field
        if paymentTextField.isEditing {
            
            paymentTextField.resignFirstResponder()
        }
        
        // dismiss keyboard for date text field
        if dateTextField.isEditing {
            
            dateTextField.text = dateFormatter.string(from: datePicker.date)
            dateTextField.resignFirstResponder()
        }
        
        // dismiss keyboard for note text field
        if noteTextField.isEditing {
            
            noteTextField.resignFirstResponder()
        }
        
        
    }
}

// MARK: Bottom Line TextField
enum LinePosition {
    case top
    case bottom
}

extension UIView {
    func addLine(position: LinePosition, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        switch position {
        case .top:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .bottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}
