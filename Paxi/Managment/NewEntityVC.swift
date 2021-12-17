//
//  NewEntityVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/7/21.
//

import UIKit

class NewEntityVC: UIViewController {

    // MARK: Properties
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
        print("Checkmark button selected!")
        
        switch self.entityType {
        case .property:
            let results = getContentFromTextFields(entityType: .property)
            
            print(results["title"]!, results["address"]!)
             
        case .unit:
            let results = getContentFromTextFields(entityType: .unit)
            
            print(results["title"]!, results["rooms"]!, results["bathrooms"]!, results["rent"]!)
            
        case .tenant:
            let results = getContentFromTextFields(entityType: .tenant)
            
            print(results["name"]!, results["email"]!, results["phone"]!, results["deposit"]!, results["startingDate"]!)
    
        case .notYetAsign:
            break
        }
        
        presentingViewController?.dismiss(animated: true)
    }
    
    func getFormFields(entityType: ManageNewEntityType) -> [String] {
        switch entityType {
        case .property:
            return ["Title", "Address"]
        case .unit:
            return ["Title", "Rooms", "Bathrooms", "Rent"]
        case .tenant:
            return ["Name", "Email", "Phone", "Deposit", "Starting Date"]
        case .notYetAsign:
            return []
        }
    }
    
    func getContentFromTextFields(entityType: ManageNewEntityType) -> [String : String] {
        switch entityType {
        case .property:
            var title: String = ""
            var address: String = ""
            
            for item in 0...1 {
                let indexPath: IndexPath = .init(item: item, section: 0)
                let cell = collectionView.cellForItem(at: indexPath) as! NewEntityFormCell
                
                if item == 0 {
                    title = cell.textField.text!
                } else {
                    address = cell.textField.text!
                }
            }
            
            return [
                "title" : title,
                "address" : address
            ]
            
        case .unit:
            var title: String = ""
            var rooms: String = ""
            var bathrooms: String = ""
            var rent: String = ""
            
            for item in 0...3 {
                let indexPath: IndexPath = .init(item: item, section: 0)
                let cell = collectionView.cellForItem(at: indexPath) as! NewEntityFormCell
                
                switch item {
                case 0:
                    title = cell.textField.text!
                case 1:
                    rooms = cell.textField.text!
                case 2:
                    bathrooms = cell.textField.text!
                case 3:
                    rent = cell.textField.text!
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
            var deposit: String = ""
            var startingDate: String = ""
            
            for item in 0...4 {
                let indexPath: IndexPath = .init(item: item, section: 0)
                let cell = collectionView.cellForItem(at: indexPath) as! NewEntityFormCell
                
                switch item {
                case 0:
                    name = cell.textField.text!
                case 1:
                    email = cell.textField.text!
                case 2:
                    phone = cell.textField.text!
                case 3:
                    deposit = cell.textField.text!
                case 4:
                    startingDate = cell.textField.text!
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
            
        case .notYetAsign:
            return ["" : ""]
        }
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
