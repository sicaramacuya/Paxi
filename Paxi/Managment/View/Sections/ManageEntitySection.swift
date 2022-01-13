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
    let entities: [Any]!
    
    
    // MARK: Methods
    init<T>(entities: [T]) {
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
        
        switch type(of: entities[0]) {
        case is Property.Type:
            let entities = self.entities as! [Property]
            let title = entities[indexPath.item].title ?? "Untitled Property"
            let amount = entities[indexPath.item].amount
            
            cell.setContent(title: title, amount: amount)
        case is Unit.Type:
            let entities = self.entities as! [Unit]
            let title = entities[indexPath.item].title ?? "Untitled Unit"
            let amount = entities[indexPath.item].amount
            
            cell.setContent(title: title, amount: amount)
            
        case is Tenant.Type:
            let entities = self.entities as! [Tenant]
            let title = entities[indexPath.item].name!
            let amount = entities[indexPath.item].amount
            
            cell.setContent(title: title, amount: amount)
            
        case is Rent.Type:
            let entities = self.entities as! [Rent]
            let title = entities[indexPath.item].datePayment?.formatted(date: .abbreviated, time: .omitted) ?? "Error"
            let amount = entities[indexPath.item].payment
            
            cell.setContent(title: title, amount: amount)
            
        default:
            break
        }
        
        return cell
    }
}

