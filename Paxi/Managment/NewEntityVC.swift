//
//  NewEntityVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/7/21.
//

import UIKit

class NewEntityVC: UIViewController {

    // MARK: Properties
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
        NewEntityTitleSection(title: self.title!),
        //ManageEntitySection(entities: entries)
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
        
        //setupTitleView()
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
    
    func setupCollectionView() {
        // setting delegate and data source
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // registering
        collectionView.register(NewEntityTitleCell.self, forCellWithReuseIdentifier: NewEntityTitleCell.identifier)
        //collectionView.register(ManageEntityCell.self, forCellWithReuseIdentifier: ManageEntityCell.identifier)
        
        // adding to the view
        self.view.addSubview(collectionView)
        
        // reloads all data in collectionView
        collectionView.reloadData()
    }
    
    @objc func cancelButtonSelected() {
        print("Cancel button selected!")
        
        
        presentingViewController?.dismiss(animated: true)
    }
    
    @objc func checkMarkButtonSelected() {
        print("Checkmark button selected!")
        
        
        presentingViewController?.dismiss(animated: true)
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
        
    }
}
