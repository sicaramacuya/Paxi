//
//  NewEntityPreviewSection.swift
//  Paxi
//
//  Created by Eric Morales on 12/10/21.
//

import UIKit

struct NewEntityPreviewSection: Section {
    
    // MARK: Properties
    let numberOfItems: Int = 1
    let entities: Any
    
    
    // MARK: Methods
    init<T>(entities: T) {
        self.entities = entities
    }
    
    func layoutSection() -> NSCollectionLayoutSection? {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(20), trailing: nil, bottom: nil)
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NewEntityPreviewCell.self), for: indexPath) as! NewEntityPreviewCell
        
        switch type(of: entities) {
        case is ManageTestingProperty.Type:
            let entities = self.entities as! ManageTestingProperty
            let title = entities.title
            
            cell.setContent(title: title)
        
        case is ManageTestingUnit.Type:
            let entities = self.entities as! ManageTestingUnit
            let title = entities.title
            
            cell.setContent(title: title)
            
        case is ManageTestingTenant.Type:
            let entities = self.entities as! ManageTestingTenant
            let title = entities.title
            
            cell.setContent(title: title)
            
        case is ManageTestingPayments.Type:
            let entities = self.entities as! ManageTestingPayments
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, y"
            let title = dateFormatter.string(from: entities.date)
            
            cell.setContent(title: title)
            
        default:
            break
        }
        
        return cell
    }
}

