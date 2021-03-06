//
//  PaymentTitleView.swift
//  Paxi
//
//  Created by Eric Morales on 1/5/22.
//

import UIKit

class PaymentTitleView: NewEntityTitleView {
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, tintColor: UIColor) {
        self.init()
        
        self.mainLabel.text = title
        self.cancelButton.tintColor = tintColor
        self.checkMarkButton.tintColor = tintColor
    }
}
