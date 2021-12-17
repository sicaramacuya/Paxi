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
    //lazy var form: NewEntityFromView = NewEntityFromView(parentVC: self.view)
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        //setupForm()
        
        
        
        
//        collectionView.register(MyHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    // MARK: Methods
    func setupCollectionView() {
        // properties
        collectionView.frame = self.view.bounds
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        
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
    
    func setupForm() {
    
        // adding to view hierachy
        //self.view.addSubview(form)
    
        // add constrains
        //form.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -50).isActive = true
        //form.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor).isActive = true
        //form.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor).isActive = true
        //form.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
    }
}

//class MyHeader: UICollectionReusableView {
//    lazy var someTextLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 20)
//        label.text = "Hello I'm a header!"
//
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addSubview(someTextLabel)
//
//        NSLayoutConstraint.activate([
//            someTextLabel.topAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
//            someTextLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            someTextLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            someTextLabel.heightAnchor.constraint(equalToConstant: 30)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}



extension NewEntityHeaderCVC {
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
//
//        return supplementaryView
//    }
    
    
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
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 0 {
//            return CGSize(width: view.frame.width, height: 80)
//        } else {
//            return .zero
//        }
//    }
    
    // MARK: CollectionView Delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
