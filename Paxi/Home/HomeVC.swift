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
                                            .dashboard,
                                            .managment,
                                            .payment,
                                            .history,
                                            .tenants,
                                            .units
    ]
    lazy var sections: [Section] = [
        QuickSelectionSection(selection: quickSelection),
        TitleSection(title: "Properties"),
        PropertiesSection(properties: properties)
    ]
    lazy var properties = self.getHardCodedProperties()
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.view.backgroundColor = .systemBackground
        
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: Methods
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
}

extension HomeVC {
    // MARK: Hard Coded Content
    func getHardCodedProperties() -> [TestingProperties] {
        return [
            TestingProperties(title: "Pitahaya"),
            TestingProperties(title: "Collores"),
            TestingProperties(title: "Anton Ruiz"),
            TestingProperties(title: "Tejas"),
            TestingProperties(title: "Leguisamo"),
            TestingProperties(title: "Miradero")
        ]
    }
}
