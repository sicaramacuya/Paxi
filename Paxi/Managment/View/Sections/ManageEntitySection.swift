//
//  ManageEntitySection.swift
//  Paxi
//
//  Created by Eric Morales on 12/6/21.
//

import UIKit

struct ManageEntitySection: Section {
    
    // MARK: Properties
    let numberOfItems: Int
    let entities: [ManageTestingProperty]!
    
    
    // MARK: Methods
    init(entities: [ManageTestingProperty]) {
        self.numberOfItems = entities.count
        self.entities = entities
    }
    
    func layoutSection() -> NSCollectionLayoutSection? {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.125))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ManageEntityCell.self), for: indexPath) as! ManageEntityCell
        cell.setContent(title: entities[indexPath.item].title, amount: entities[indexPath.item].amount)
        
        return cell
    }
}

