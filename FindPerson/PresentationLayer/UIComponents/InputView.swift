//
//  InputView.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal class InputView: UIView {
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.applySketchShadow(color: .black,
                                alpha: 0.2,
                                x: 0.0,
                                y: 4.0,
                                blur: 16.0,
                                spread: 0.0)
        layer.masksToBounds = false
        layer.cornerRadius = 8.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
