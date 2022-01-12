//
//  ManageTitleSection.swift
//  Paxi
//
//  Created by Eric Morales on 12/6/21.
//

import UIKit

struct ManageTitleSection: Section {
    
    // MARK: Properties
    let numberOfItems: Int = 1
    let mainTitle: String
    let subTitle: String
    let delegate: UIViewController
    
    
    // MARK: Methods
    init(mainTitle: String, subTitle: String, delegate: UIViewController) {
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.delegate = delegate
    }
    
    func layoutSection() -> NSCollectionLayoutSection? {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.08))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ManageTitleCell.self), for: indexPath) as! ManageTitleCell
        cell.delegate = self.delegate as! ManageTitleCellButtonSelectionDelegate?
        cell.setContent(subTitle: self.subTitle)
        
        return cell
    }
}
