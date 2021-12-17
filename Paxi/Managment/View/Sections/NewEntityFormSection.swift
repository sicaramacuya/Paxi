//
//  NewEntityFormSection.swift
//  Paxi
//
//  Created by Eric Morales on 12/17/21.
//

import UIKit

struct NewEntityFormSection: Section {
    
    // MARK: Properties
    let numberOfItems: Int 
    let title: [String]
    
    
    // MARK: Methods
    init(title: [String]) {
        self.numberOfItems = title.count
        self.title = title
    }
    
    func layoutSection() -> NSCollectionLayoutSection? {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(20), trailing: nil, bottom: nil)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.08))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        //group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NewEntityFormCell.self), for: indexPath) as! NewEntityFormCell
        
        cell.setContent(title: self.title[indexPath.item])
        
        return cell
    }
}
