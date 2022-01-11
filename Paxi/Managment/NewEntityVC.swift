//
//  NewEntityVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/7/21.
//

import UIKit

class NewEntityVC: UIViewController {

    // MARK: Properties
    var item: Any?
    var manageVC: ManageVC?
    lazy var entityType: ManageNewEntityType = .notYetAsign
    lazy var titleView: UIView = NewEntityTitleView(title: self.title!)
    lazy var previewView: UIView = NewEntityPreviewView(title: "Aguacate")
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill // direction of axis
        stack.alignment = .fill // direction perpendiculat to the axis
        stack.spacing = 5
        
        return stack
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.collectionViewLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
                                              
        return collectionView
    }()
    lazy var collectionViewLayout: UICollectionViewLayout = {
        var sections = self.sections
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            return sections[sectionIndex].layoutSection()
        }
        return layout
    }()
    lazy var sections: [Section] = [
        NewEntityFormSection(title: getFormFields(entityType: entityType))
    ]
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
    
    
    // MARK: Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        self.view.addGestureRecognizer(tapGesture)
        
        setupStack()
        setupCollectionView()
    }
    
    
    // MARK: Methods
    func setupNavigationController() {
        // style title
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let titleTextAttribute: [NSAttributedString.Key : Any] = [ .foregroundColor: UIColor.clear,]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute
        
        // add color
        self.navigationController?.navigationBar.tintColor = .systemYellow
    }
    
    func setupStack() {
        // add hierarchy
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(previewView)
        stackView.addArrangedSubview(collectionView)
        
        // constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            titleView.heightAnchor.constraint(equalTo: previewView.heightAnchor),
        ])
    }
    
    func setupCollectionView() {
        // setting delegate and data source
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // registering
        collectionView.register(NewEntityFormCell.self, forCellWithReuseIdentifier: NewEntityFormCell.identifier)
        
        // reloads all data in collectionView
        collectionView.reloadData()
    }
    
    @objc func cancelButtonSelected() {
        print("Cancel button selected!")
        
        
        presentingViewController?.dismiss(animated: true)
    }
    
    @objc func checkMarkButtonSelected() {
        // This switch is to get the content in the text field and called the save method on it.
        switch self.entityType {
        case .property:
            let results = getContentFromTextFields(entityType: .property)
            if !results.isEmpty {
                save(results: results)
                print("Property has been saved.")
            } else {
                print("Didn't save, fields for the new property wheren't fill out properly.")
            }
             
        case .unit:
            let results = getContentFromTextFields(entityType: .unit)
            if !results.isEmpty {
                save(results: results)
                print("Unit has been saved.")
            } else {
                print("Didn't save, fields for the new unit wheren't fill out properly.")
            }
            
        case .tenant:
            let results = getContentFromTextFields(entityType: .tenant)
            if !results.isEmpty {
                save(results: results)
                print("Tenant has been saved.")
            } else {
                print("Didn't save, fields for the new tenant wheren't fill out properly.")
            }
    
        case .payment:
            let results = getContentFromTextFields(entityType: .payment)
            if !results.isEmpty {
                save(results: results)
                print("Payment has been saved.")
            } else {
                print("Didn't save, fields for the new payment wheren't fill out properly.")
            }
        
        case .notYetAsign:
            break
        }
        
        presentingViewController?.dismiss(animated: true)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        collectionView.endEditing(true)
    }
    
    func getFormFields(entityType: ManageNewEntityType) -> [String] {
        switch entityType {
        case .property:
            return ["Title", "Address"]
        case .unit:
            return ["Title", "Rooms", "Bathrooms", "Rent"]
        case .tenant:
            return ["Name", "Email", "Phone", "Deposit", "Starting Date (e.g., 'April 05, 2021')"]
        case .payment:
            guard let tenant = item as? Tenant else {
                fatalError("fatalError trying to cast item as a Tenant inside getFormFields()")
            }
            guard let tenantName = tenant.name else {
                fatalError("fatalError trying to access tenant's name")
            }
            guard let tenantProperty = tenant.unit?.property?.title else {
                fatalError("fatalError trying to access tenant's property")
            }
            guard let tenantUnit = tenant.unit?.title else {
                fatalError("fatalError trying to access tenant's unit")
            }
            guard let unitRent = tenant.unit?.rent else {
                fatalError("fatalError trying to access unit's rent")
            }
            
            return [tenantName, tenantProperty, tenantUnit, String(unitRent), "Actual Payment", "Date (e.g., 'April 05, 2021')", "Note"]
        case .notYetAsign:
            return []
        }
    }
    
    func getContentFromTextFields(entityType: ManageNewEntityType) -> [String : Any] {
        switch entityType {
        case .property:
            var title: String = ""
            var address: String = ""
            
            for item in 0...1 {
                let indexPath: IndexPath = .init(item: item, section: 0)
                let cell = collectionView.cellForItem(at: indexPath) as! NewEntityFormCell
                
                if item == 0 {
                    let titleText = cell.textField.text ?? ""
                    if titleText == "" { return [:] }
                    
                    title = titleText
                } else {
                    let addressText = cell.textField.text ?? ""
                    if addressText == "" { return [:] }
                    
                    address = addressText
                }
            }
            
            return [
                "title" : title,
                "address" : address
            ]
            
        case .unit:
            var title: String = ""
            var rooms: Int16 = 0
            var bathrooms: Int16 = 0
            var rent: Double = 0.00
            
            for item in 0...3 {
                let indexPath: IndexPath = .init(item: item, section: 0)
                let cell = collectionView.cellForItem(at: indexPath) as! NewEntityFormCell
                
                switch item {
                case 0:
                    let titleText = cell.textField.text ?? ""
                    if titleText == "" { return [:] }
                    
                    title = titleText
                case 1:
                    let roomsText = cell.textField.text ?? ""
                    if roomsText == "" { return [:] }
                    guard let roomsInt16 = Int16(roomsText) else {
                        fatalError("Rooms not able to cast as Int16.")
                    }
                    
                    rooms = roomsInt16
                case 2:
                    let bathroomsText = cell.textField.text ?? ""
                    if bathroomsText == "" { return [:] }
                    guard let bathroomsInt16 = Int16(bathroomsText) else {
                        fatalError("Bathrooms not able to cast as Int16.")
                    }
                    
                    bathrooms = bathroomsInt16
                case 3:
                    let rentText = cell.textField.text ?? ""
                    if rentText == "" { return [:] }
                    guard let rentDouble = Double(rentText) else {
                        fatalError("Rent not able to cast as Double.")
                    }
                    
                    rent = rentDouble
                default:
                    break
                }
            }
            
            return [
                "title" : title,
                "rooms" : rooms,
                "bathrooms" : bathrooms,
                "rent" : rent
            ]
            
        case .tenant:
            var name: String = ""
            var email: String = ""
            var phone: String = ""
            var deposit: Double = 0.00
            var startingDate: Date = Date()
            
            for item in 0...4 {
                let indexPath: IndexPath = .init(item: item, section: 0)
                let cell = collectionView.cellForItem(at: indexPath) as! NewEntityFormCell
                
                switch item {
                case 0:
                    let nameText = cell.textField.text ?? ""
                    if nameText == "" { return [:] }
                    
                    name = nameText
                case 1:
                    let emailText = cell.textField.text ?? ""
                    if emailText == "" { return [:] }
                    
                    email = emailText
                case 2:
                    let phoneText = cell.textField.text ?? ""
                    if phoneText == "" { return [:] }
                    
                    phone = phoneText
                case 3:
                    let depositText = cell.textField.text ?? ""
                    if depositText == "" { return [:] }
                    guard let depositDouble = Double(depositText) else {
                        fatalError("Deposit not able to cast as Double.")
                    }
                    
                    deposit = depositDouble
                case 4:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM dd, y"
                    if cell.textField.text == "" {
                        return [
                            "name" : name,
                            "email" : email,
                            "phone" : phone,
                            "deposit" : deposit,
                            "startingDate" : startingDate
                        ]
                    }
                    
                    startingDate = dateFormatter.date(from: cell.textField.text!)!
                    
                    
                default:
                    break
                }
            }
            
            return [
                "name" : name,
                "email" : email,
                "phone" : phone,
                "deposit" : deposit,
                "startingDate" : startingDate
            ]
            
        case .payment:
            guard let tenant = item as? Tenant else {
                fatalError("fatalError trying to cast item as a Tenant inside getFormFields()")
            }
            guard let property = tenant.unit?.property else {
                fatalError("fatalError trying to access tenant's property")
            }
            guard let unit = tenant.unit else {
                fatalError("fatalError trying to access tenant's unit")
            }
            var rent: Double = 0.00
            var actualPayment: Double = 0.00
            var date: Date = Date()
            var note: String = ""
            
            for item in 0...6 {
                let indexPath: IndexPath = .init(item: item, section: 0)
                let cell = collectionView.cellForItem(at: indexPath) as! NewEntityFormCell
                
                switch item {
                case 0:
                    // Ignoring the tenant.
                    break
                case 1:
                    // Ignoring the propery.
                    break
                case 2:
                    // Ignoring the unit.
                    break
                case 3:
                    guard let tenant = self.item as? Tenant else {
                        fatalError("fatalError trying to cast item as a Tenant inside getFormFields()")
                    }
                    guard let unitRent = tenant.unit?.rent else {
                        fatalError("fatalError trying to access unit's rent")
                    }
                    
                    let rentText = cell.textField.text ?? "" // get field if empty make sure is an empty string
                    if rentText == "" { rent = unitRent; break } // if there is a empty string is because there where no changes. So save the actual rent for the unit
                    guard let rentDouble = Double(rentText) else {
                        fatalError("Deposit not able to cast as Double.")
                    }
                    
                    rent = rentDouble
                case 4:
                    let actualPaymentText = cell.textField.text ?? ""
                    if actualPaymentText == "" { return [:] }
                    guard let actualPaymentDouble = Double(actualPaymentText) else {
                        fatalError("Deposit not able to cast as Double.")
                    }
                    
                    actualPayment = actualPaymentDouble
                case 5:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM dd, y"
                    if cell.textField.text == "" {
                        return [
                            "tenant" : tenant,
                            "property" : property,
                            "unit" : unit,
                            "rent" : rent,
                            "actualPayment" : actualPayment,
                            "date" : date,
                            "note" : note
                        ]
                    }
                    
                    date = dateFormatter.date(from: cell.textField.text!)!
                case 6:
                    note = cell.textField.text!
                default:
                    break
                }
            }
            
            return [
                "tenant" : tenant,
                "property" : property,
                "unit" : unit,
                "rent" : rent,
                "actualPayment" : actualPayment,
                "date" : date,
                "note" : note
            ]
            
        case .notYetAsign:
            return ["" : ""]
        }
    }
    
    func save(results: [String:Any]) {
        let stack = CDStack.shared
        let context = stack.persistentContainer.viewContext
        switch entityType {
        case .property:
            let property = Property(context: context)
            property.title = results["title"] as? String
            property.address = results["address"] as? String
            
        case .unit:
            let unit = Unit(context: context)
            unit.title = results["title"] as? String
            unit.rooms = results["rooms"] as! Int16
            unit.bathrooms = results["bathrooms"] as! Int16
            unit.rent = results["rent"] as! Double
            
            guard let property = item as? Property else {
                fatalError("fatalError trying to cast item as a Property inside save()")
            }
            
            unit.property = property
        case .tenant:
            let tenant = Tenant(context: context)
            tenant.name = results["name"] as? String
            tenant.email = results["email"] as? String
            tenant.phone = results["phone"] as? String
            tenant.deposit = results["deposit"] as! Double
            tenant.startingDate = results["startingDate"] as? Date
            
            guard let unit = item as? Unit else {
                fatalError("fatalError trying to cast item as a Unit inside save()")
            }
            
            tenant.unit = unit
            tenant.property = unit.property
        case .payment:
            let payment = Payment(context: context)
            payment.tenant = results["tenant"] as? Tenant
            payment.property = results["property"] as? Property
            payment.unit = results["unit"] as? Unit
            payment.rent = results["rent"] as! Double
            payment.payment = results["actualPayment"] as! Double
            payment.date = results["date"] as? Date
            payment.note = results["note"] as? String
            
        case .notYetAsign:
            break
        }
        
        stack.saveContext()
    }
}

extension NewEntityVC: UICollectionViewDataSource {
    // MARK: CollectionView DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.sections[indexPath.section].configureCell(collectionView: collectionView, indexPath: indexPath)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
}

extension NewEntityVC: UICollectionViewDelegate {
    // MARK: CollectionView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
