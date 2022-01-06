//
//  HomeVC.swift
//  Paxi
//
//  Created by Eric Morales on 11/30/21.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: Properties
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
    lazy var quickSelection: [Selection] = [
                                            .agenda,
                                            //.dashboard,
                                            .managment,
                                            .payment,
                                            .history,
                                            //.tenants,
                                            //.units
    ]
    lazy var sections: [Section] = [
        QuickSelectionSection(selection: quickSelection),
        TitleSection(title: "Properties"),
        PropertiesSection(properties: properties)
    ]
    lazy var properties = self.getProperties()
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.view.backgroundColor = .systemBackground
        
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
        // add edit button
        let editBarItem = UIBarButtonItem(title: "Edit", style: .plain, target: .none, action: .none)
        self.navigationItem.rightBarButtonItem = editBarItem
        
        // style title
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let titleTextAttribute: [NSAttributedString.Key : Any] = [ .foregroundColor: UIColor.clear,]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute
        
        // add color
        self.navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    func setupCollectionView() {
        // setting delegate and data source
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // registering
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.identifier)
        collectionView.register(QuickSelectionCell.self, forCellWithReuseIdentifier: QuickSelectionCell.identifier)
        collectionView.register(PropertiesCell.self, forCellWithReuseIdentifier: PropertiesCell.identifier)
        
        // adding to the view
        self.view.addSubview(collectionView)
        
        // reloads all data in collectionView
        collectionView.reloadData()
    }
}

extension HomeVC: UICollectionViewDataSource {
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

extension HomeVC: UICollectionViewDelegate {
    // MARK: CollectionView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Quick Selection Section
        if indexPath.section == 0 {
            let selection: Selection = quickSelection[indexPath.item]
            
            switch selection {
            case .agenda:
                break
                
            case .managment:
                let context = CDStack.shared.persistentContainer.viewContext
                let fetch = Property.fetchRequest()
                fetch.sortDescriptors = [] // TODO: Sort by name
                let results = try! context.fetch(fetch)
                
                let vc = ManageVC(entries: results)
                vc.subTitle = "Properties"
                
                navigationController?.pushViewController(vc, animated: true)
                
            case .payment:
                let vc = PaymentVC()
                //vc.modalPresentationStyle = .fullScreen
                navigationController?.present(vc, animated: true)
                
            case .history:
                break
                
            default:
                break
            }
        }
        
        // Properties Section
        if indexPath.section == 2 {
            print(indexPath.item)
        }
    }
}

extension HomeVC {
    // MARK: Hard Coded Content
    func getProperties() -> [Property] {
        let context = CDStack.shared.persistentContainer.viewContext
        let fetch = Property.fetchRequest()
        fetch.sortDescriptors = [] // TODO: Sort by name
        let results = try! context.fetch(fetch)
        
        return results
    }
}
