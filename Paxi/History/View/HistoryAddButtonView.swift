//
//  HistoryAddButtonView.swift
//  Paxi
//
//  Created by Eric Morales on 1/9/22.
//

import UIKit

class HistoryAddButtonView: UIButton {
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(buttonSize: CGSize, vcTintColor: UIColor) {
        self.init(frame: CGRect(x: 0, y: 0, width: buttonSize.width, height: buttonSize.height))
        
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.2
        layer.cornerRadius = buttonSize.width / 2
        backgroundColor = .secondarySystemBackground
        tintColor = vcTintColor
        
        let image = UIImage(systemName: "plus",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 40,
                                                                           weight: .regular))
        setImage(image, for: .normal)
    }
}
