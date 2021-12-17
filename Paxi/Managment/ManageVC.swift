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
    lazy var sections: [Section] = [
        ManageTitleSection(mainTitle: "Manage", subTitle: self.subTitle),
        ManageEntitySection(entities: entries)
    ]
    lazy var entries: [Any] = []
    
    
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
    
    @objc func addButtonSelected() {
        // switch set the correct title and entries for any given entity
        switch type(of: self.entries[0]) {
        case is ManageTestingProperty.Type:
            //let vc = NewEntityHeaderCVC(collectionViewLayout: UICollectionViewLayout())
            let vc = NewEntityVC()
            vc.title = "New Property"
            vc.entityType = .property
            navigationController?.present(vc, animated: true)
            
        case is ManageTestingUnit.Type:
            let vc = NewEntityVC()
            vc.title = "New Unit"
            vc.entityType = .unit
            navigationController?.present(vc, animated: true)
            
        case is ManageTestingTenant.Type:
            let vc = NewEntityVC()
            vc.title = "New Tenant"
            vc.entityType = .tenant
            navigationController?.present(vc, animated: true)
         
        case is ManageTestingPayments.Type:
            let vc = PaymentVC()
            navigationController?.present(vc, animated: true)
            
        default:
            return
        }
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
    
    func manageSelectionOfCell(indexPath: IndexPath) {
        // create a new view controller
        let vc = ManageVC(entries: self.entries)
        
        // switch set the correct title and entries for any given entity
        var title: String = ""
        switch type(of: vc.entries[0]) {
        case is ManageTestingProperty.Type:
            
            let entries = vc.entries as! [ManageTestingProperty]
            title = entries[indexPath.item].title
            
            vc.entries = entries[indexPath.item].units
            
        case is ManageTestingUnit.Type:
            let entries = self.entries as! [ManageTestingUnit]
            title = entries[indexPath.item].title
            
            vc.entries = entries[indexPath.item].tenants
            
        case is ManageTestingTenant.Type:
            let entries = self.entries as! [ManageTestingTenant]
            title = entries[indexPath.item].title
            
            vc.entries = entries[indexPath.item].payments
         
        case is ManageTestingPayments.Type:
            let paymentVC = PaymentVC()
            navigationController?.present(paymentVC, animated: true)
            
            return
            
        default:
            return
        }
        
        // subTitle is set the the title because this property is use to set the self.title property of the view controller
        vc.subTitle = title
        
        // sets the sessions
        vc.sections = [
            ManageTitleSection(mainTitle: "Manage", subTitle: title),
            ManageEntitySection(entities: vc.entries)
        ]
        
        // move to our new view controller
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ManageVC {
    // MARK: Hard Coded Content
    static func getHardCodedEntities() -> [ManageTestingProperty] {
        // Payments
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, y"
        
        let payment1 = ManageTestingPayments(date: dateFormatter.date(from: "September 05, 2021")!, amount: 250)
        let payment2 = ManageTestingPayments(date: dateFormatter.date(from: "October 05, 2021")!, amount: 250)
        let payment3 = ManageTestingPayments(date: dateFormatter.date(from: "November 05, 2021")!, amount: 250)
        let payment4 = ManageTestingPayments(date: dateFormatter.date(from: "December 05, 2021")!, amount: 250)
        
        // Tenants
        let ezra = ManageTestingTenant(title: "Ezra Morales", amount: 200, payments: [payment1, payment2, payment3, payment4])
        let layra = ManageTestingTenant(title: "Lyra Morales", amount: 300, payments: [payment1, payment2, payment3, payment4])
        let azul = ManageTestingTenant(title: "Azul Morales", amount: 100, payments: [payment1, payment2, payment3, payment4])
        let miles = ManageTestingTenant(title: "Miles Morales", amount: 700, payments: [payment1, payment2, payment3, payment4])
        
        // Units
        let unit1 = ManageTestingUnit(title: "Unit 1", amount: 500, tenants: [ezra])
        let unit2 = ManageTestingUnit(title: "Unit 2", amount: 500, tenants: [layra])
        let unit3 = ManageTestingUnit(title: "Unit 3", amount: 500, tenants: [azul])
        let unit4 = ManageTestingUnit(title: "Unit 4", amount: 500, tenants: [miles])
        
        return [
            ManageTestingProperty(title: "Pitahaya", amount: 250, units: [unit1, unit2, unit3, unit4]),
            ManageTestingProperty(title: "Collores", amount: 250, units: [unit1, unit2, unit3, unit4]),
            ManageTestingProperty(title: "Antón Ruíz", amount: 150, units: [unit1, unit2, unit3, unit4]),
            ManageTestingProperty(title: "Tejas", amount: 900.25, units: [unit1, unit2, unit3, unit4]),
            ManageTestingProperty(title: "Leguisamo", amount: 100, units: [unit1, unit2, unit3, unit4]),
            ManageTestingProperty(title: "Miradero", amount: 12500, units: [unit1, unit2, unit3, unit4])
        ]
    }
}
