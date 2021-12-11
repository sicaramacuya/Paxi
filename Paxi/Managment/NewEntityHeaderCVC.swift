//
//  NewEntityHeaderCVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/9/21.
//

import UIKit

class NewEntityHeaderCVC: UICollectionViewController {

    // MARK: Properties
    lazy var testingPropertyTitle: String = "Aguacate"
    lazy var entity: Any = ManageTestingProperty(title: self.testingPropertyTitle, amount: 0.00, units: [])
    lazy var sections: [Section] = [
        NewEntityTitleSection(title: self.title!),
        NewEntityPreviewSection(entities: self.entity)
    ]
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    // MARK: Methods
    func setupCollectionView() {
        // properties
        collectionView.frame = self.view.bounds
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        // collectionViewLayout
        collectionView.collectionViewLayout = {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                
                return self.sections[sectionIndex].layoutSection()
            }
            return layout
        }()
        
        // setting delegate and data source
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // registering
        collectionView.register(NewEntityTitleCell.self, forCellWithReuseIdentifier: NewEntityTitleCell.identifier)
        collectionView.register(NewEntityPreviewCell.self, forCellWithReuseIdentifier: NewEntityPreviewCell.identifier)
        
        // adding to the view
        self.view.addSubview(collectionView)
        
        // reloads all data in collectionView
        collectionView.reloadData()
    }
}

extension NewEntityHeaderCVC {
    // MARK: CollectionView DataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.sections[indexPath.section].configureCell(collectionView: collectionView, indexPath: indexPath)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
}

extension NewEntityHeaderCVC {
    // MARK: CollectionView Delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
