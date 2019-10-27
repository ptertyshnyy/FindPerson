//
//  AlertWindowController.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 24/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal class AlertWindowController: UIAlertController {

    // MARK: - Properties

    private let alertWindow: UIWindow
    
    // MARK: - Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.windowLevel = UIWindow.Level.statusBar - 0.1
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle

    func show(animated: Bool = true) {
        let viewController = RootAlertWindowController()
        alertWindow.rootViewController = viewController
        alertWindow.makeKeyAndVisible()

        if let tintColor = UIApplication.shared.delegate?.window??.tintColor {
            alertWindow.tintColor = tintColor
        }
        
        viewController.present(self, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // return keyboard events to app main window
        UIApplication.shared.delegate?.window??.makeKey()
    }
    
    static func isAlertWindow(_ window: UIWindow) -> Bool {
        return window.rootViewController is RootAlertWindowController
    }

}

private class RootAlertWindowController: UIViewController {

    // MARK: - Properties

    private var statusBarStyle: UIStatusBarStyle = .default

    private var statusBarHidden: Bool = false

    // MARK: - Status bar appearance

    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topVC = UIApplication.shared.delegate?.window??.rootViewController?.leafViewController else {
            return statusBarStyle
        }
        if !topVC.isKind(of: RootAlertWindowController.self) {
            statusBarStyle = topVC.preferredStatusBarStyle
        }
        return statusBarStyle
    }

    override var prefersStatusBarHidden: Bool {
        guard let topVC = UIApplication.shared.delegate?.window??.rootViewController?.leafViewController else {
            return statusBarHidden
        }
        if !topVC.isKind(of: RootAlertWindowController.self) {
            statusBarHidden = topVC.prefersStatusBarHidden
        }
        return statusBarHidden
    }
}
