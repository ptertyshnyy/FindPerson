//
//  RootViewController.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 23/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal protocol RootControllerLogic: class {
    func displayLoad(viewModel: RootDataFlow.Load.ViewModel)
}

internal protocol RootModuleOutput: class {

}

internal protocol RootModuleInput: class {

}

internal protocol RootModuleBuilders {
    var peopleList: PeopleListBuildable { get }
    var peopleDetail: PeopleDetailBuildable { get }
}

internal class RootViewController: UINavigationController, RootControllerLogic, RootModuleInput {

    // MARK: - Properties

    var interactor: RootBusinessLogic?

    weak var moduleOutput: RootModuleOutput?
    
    private let builders: RootModuleBuilders
    
    private let dismissInteractor: DismissInteractor = DismissInteractor()

    // MARK: - Init
    
    init(builders: RootModuleBuilders) {
        self.builders = builders
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        startLoading()
    }

    // MARK: - RootControllerLogic

    private func startLoading() {
        let request = RootDataFlow.Load.Request()
        interactor?.load(request: request)
    }

    func displayLoad(viewModel: RootDataFlow.Load.ViewModel) {
        let initialController = builders.peopleList.build(withModuleOutput: self)
        viewControllers = [initialController]
    }

}

extension RootViewController: PeopleListModuleOutput {
    
    func peopleListModuleDidShowPeopleDetail(people: People) {
        let viewController = builders.peopleDetail.build(withModuleOutput: self,
                                                         people: people)
        dismissInteractor.viewController = viewController
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: true)
    }
}

extension RootViewController: PeopleDetailModuleOutput {
    
}

extension RootViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        let presentationController = DimmingPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        presentationController.dismissOnBackgroundTap = true
        presentationController.dimColor = UIColor(white: 0.0, alpha: 0.7)
        presentationController.contentCornerRadius = 8.0
        return presentationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator(direction: .down)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) ->
        UIViewControllerInteractiveTransitioning? {
            return dismissInteractor.hasStarted ? dismissInteractor : nil
    }
}
