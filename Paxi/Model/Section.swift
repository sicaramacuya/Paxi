//
//  Section.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

protocol Section {
    var numberOfItems: Int { get }
    
    func layoutSection() -> NSCollectionLayoutSection?
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}
