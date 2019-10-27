//
//  UIViewController+Extensions.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var leafViewController: UIViewController {
        if let vc = (self as? UINavigationController)?.topViewController {
            return vc.leafViewController
        }
        if let vc = (self as? UITabBarController)?.selectedViewController {
            return vc.leafViewController
        }
        if let vc = presentedViewController {
            return vc.leafViewController
        }
        return self
    }
}
