//
//  PropertiesSection.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

struct PropertiesSection: Section {
    
    // MARK: Properties
    let numberOfItems: Int
    let properties: [TestingProperties]!
    
    
    // MARK: Methods
    init(properties: [TestingProperties]) {
        self.numberOfItems = properties.count
        self.properties = properties
    }
    
    func layoutSection() -> NSCollectionLayoutSection? {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.09))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PropertiesCell.self), for: indexPath) as! PropertiesCell
        cell.setContent(property: properties[indexPath.item])
        
        return cell
    }
}
