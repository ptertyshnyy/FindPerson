//
//  UIAlertViewController+Extensions.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func alert(title: String?, message: String, cancel: String) -> Self {
        let alertController = self.init(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: cancel, style: .cancel))
        return alertController
    }
}
