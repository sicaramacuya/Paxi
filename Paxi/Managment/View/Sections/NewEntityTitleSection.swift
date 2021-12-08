//
//  NewEntityTitleSection.swift
//  Paxi
//
//  Created by Eric Morales on 12/7/21.
//

import UIKit

struct NewEntityTitleSection: Section {
    
    // MARK: Properties
    let numberOfItems: Int = 1
    let title: String
    
    
    // MARK: Methods
    init(title: String) {
        self.title = title
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NewEntityTitleCell.self), for: indexPath) as! NewEntityTitleCell
        
        cell.setContent(title: self.title)
        
        return cell
    }
}
