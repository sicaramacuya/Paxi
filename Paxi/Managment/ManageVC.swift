//
//  ManageVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

class ManageVC: UIViewController {
    
    // MARK: Properties
    lazy var mainTitle: String = ""
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
        ManageTitleSection(mainTitle: self.mainTitle, subTitle: self.subTitle),
        ManageEntitySection(entities: entities)
    ]
    lazy var entities: [ManageTestingProperty] = self.getHardCodedEntities()
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = subTitle
        self.view.backgroundColor = .systemBackground
        
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
        print(entities[indexPath.item].title)
        
        let vc = ManageVC()
        vc.subTitle = entities[indexPath.item].title
        //vc.entities = entities[indexPath.item].unit
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}


extension ManageVC {
    // MARK: Hard Coded Content
    func getHardCodedEntities() -> [ManageTestingProperty] {
        // Tenants
        let ezra = ManageTestingTenant(title: "Ezra Morales", amount: 200)
        let layra = ManageTestingTenant(title: "Layra Morales", amount: 300)
        let azul = ManageTestingTenant(title: "Azul Morales", amount: 100)
        
        // Units
        let unit1 = ManageTestingUnit(title: "Unit 1", amount: 500, tenant: [ezra])
        let unit2 = ManageTestingUnit(title: "Unit 2", amount: 500, tenant: [layra])
        let unit3 = ManageTestingUnit(title: "Unit 3", amount: 500, tenant: [azul])
        
        return [
            ManageTestingProperty(title: "Pitahaya", amount: 250, unit: [unit1, unit2, unit3]),
            ManageTestingProperty(title: "Collores", amount: 250, unit: [unit1, unit2, unit3]),
            ManageTestingProperty(title: "Antón Ruíz", amount: 150, unit: [unit1, unit2, unit3]),
            ManageTestingProperty(title: "Tejas", amount: 900.25, unit: [unit1, unit2, unit3]),
            ManageTestingProperty(title: "Leguisamo", amount: 100, unit: [unit1, unit2, unit3]),
            ManageTestingProperty(title: "Miradero", amount: 12500, unit: [unit1, unit2, unit3])
        ]
    }
}
