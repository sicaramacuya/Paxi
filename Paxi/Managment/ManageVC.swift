//
//  ManageVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

class ManageVC: UIViewController {
    
    // MARK: Properties
    lazy var subTitle: String = ""
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.collectionViewLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    lazy var collectionViewLayout: UICollectionViewLayout = {
        var sections = self.sections
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            return sections[sectionIndex].layoutSection()
        }
        return layout
    }()
    var sections: [Section] {
        return [
            ManageTitleSection(mainTitle: "Manage", subTitle: self.subTitle, delegate: self),
            ManageEntitySection(entities: entries)
        ]
    }
    var item: Any?
    var entries: [Any] = []
    
    
    // MARK: Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(entries: [Any]) {
        self.init(nibName: nil, bundle: nil)
        
        self.entries = entries
    }
    
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.title = subTitle
        
        setupNavigationController()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if item == nil {
            let context = CoreDataStack.shared.persistentContainer.viewContext
            let fetch = Property.fetchRequest()
            fetch.sortDescriptors = [] // TODO: Sort by name
            entries = try! context.fetch(fetch)
        } else if let property = item as? Property {
            entries = property.allUnits
        } else if let unit = item as? Unit {
            entries = unit.allTenants
        } else if let tenant = item as? Tenant {
            entries = tenant.allPayments
        }
        collectionView.reloadData()
        
        setupNavigationController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
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
    
    func setupCollectionView() {
        // setting delegate and data source
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // registering
        collectionView.register(ManageTitleCell.self, forCellWithReuseIdentifier: ManageTitleCell.identifier)
        collectionView.register(ManageEntityCell.self, forCellWithReuseIdentifier: ManageEntityCell.identifier)
        
        // adding to the view
        self.view.addSubview(collectionView)
        
        // reloads all data in collectionView
        collectionView.reloadData()
    }
}

extension ManageVC: UICollectionViewDataSource {
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

extension ManageVC: UICollectionViewDelegate {
    // MARK: CollectionView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellsSection = 1
        if indexPath.section == cellsSection {
            manageSelectionOfCell(indexPath: indexPath)
        }
    }
    
    func managePaymentSelection(indexPath: IndexPath) {
        
        let payment = self.entries[indexPath.item] as! Rent
        let paymentSelected = payment
        guard let property = paymentSelected.tenant?.unit?.property else { return }
        guard let unit = paymentSelected.tenant?.unit else { return }
        guard let tenant = paymentSelected.tenant else { return }
        
        
        let paymentVC = PaymentVC()
        paymentVC.titleView.mainLabel.text = "Payment"
        paymentVC.titleView.mainLabel.textColor = .systemYellow
        paymentVC.titleView.cancelButton.isHidden = true
        paymentVC.titleView.checkMarkButton.isHidden = true
        paymentVC.vcTintColor = .systemOrange
        
        navigationController?.present(paymentVC, animated: true)
        
        // Populating Fields
        paymentVC.formView.propertyTextField.text = property.title
        paymentVC.formView.unitTextField.text = unit.title
        paymentVC.formView.tenantTextField.text = tenant.name
        paymentVC.formView.rentTextField.text = String(paymentSelected.rent)
        paymentVC.formView.paymentTextField.text = String(paymentSelected.payment)
        paymentVC.formView.dateTextField.text = paymentSelected.datePayment!.formatted(date: .long, time: .omitted)
        paymentVC.formView.noteTextField.text = paymentSelected.note ?? ""
        
        // Disabling Fields
        paymentVC.formView.propertyTextField.isEnabled = false
        paymentVC.formView.unitTextField.isEnabled = false
        paymentVC.formView.tenantTextField.isEnabled = false
        paymentVC.formView.rentTextField.isEnabled = true
        paymentVC.formView.paymentTextField.isEnabled = true
        paymentVC.formView.dateTextField.isEnabled = true
        paymentVC.formView.noteTextField.isEnabled = true
    }
    
    func manageSelectionOfCell(indexPath: IndexPath) {
        // create a new view controller
        let vc = ManageVC(entries: entries)
        
        // switch set the correct title and entries for any given entity
        var title: String = ""
        switch type(of: vc.entries[0]) {
        case is Property.Type:
            let entries = vc.entries as! [Property]
            let property = entries[indexPath.item]
            title = property.title!
            
            vc.item = property
            vc.entries = property.allUnits
        case is Unit.Type:
            let entries = vc.entries as! [Unit]
            let unit = entries[indexPath.item]
            title = unit.title!
            
            vc.item = unit
            vc.entries = unit.allTenants
        case is Tenant.Type:
            let entries = vc.entries as! [Tenant]
            let tenant = entries[indexPath.item]
            title = tenant.name!
            
            vc.item = tenant
            vc.entries = tenant.allPayments
            
        case is Rent.Type:
            self.managePaymentSelection(indexPath: indexPath)

            return
        default:
            return
        }
        
        // subTitle is set the the title because this property is use to set the self.title property of the view controller
        vc.subTitle = title
        
        // move to our new view controller
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ManageVC: ManageTitleCellButtonSelectionDelegate {
    // MARK: ManageTitleCellButtonSelectionDelegate
    
    func buttonSelected(plusButton: UIButton) {
        if item == nil {
            // this is showing a list of properties
            let vc = NewEntityVC()
            vc.title = "New Property"
            vc.entityType = .property
            vc.manageVC = self
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
            
        } else if let property = item as? Property {
            // this is showing a list of units
            let vc = NewEntityVC()
            vc.title = "New Unit"
            vc.item = property
            vc.entityType = .unit
            vc.manageVC = self
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
        } else if let unit = item as? Unit {
            // this is showing a list of tenants
            let vc = NewEntityVC()
            vc.title = "New Tenant"
            vc.item = unit
            vc.entityType = .tenant
            vc.manageVC = self
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
        } else if let tenant = item as? Tenant {
            // this is showing a list of payment
            let vc = NewEntityVC()
            vc.title = "New Payment"
            vc.item = tenant
            vc.entityType = .payment
            vc.manageVC = self
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
        }
    }
}
