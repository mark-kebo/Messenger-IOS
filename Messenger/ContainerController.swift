//
//  ContentController.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 18.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//
// cocoa pods

import UIKit

class ContainerController: UIViewController {
    
    private let containerView = UIView()
    private var controller: UIViewController?
    
    public func addControllerToContainer(controller: UIViewController) {
        if self.controller != nil {
            removeControllerInContauner()
        }
        self.controller = controller
        self.addAsChildController(childVC: self.controller!)
        self.controller?.view.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
    
    private func addAsChildController(childVC: UIViewController) {
        addChildViewController(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        childVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        childVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        childVC.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        childVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        childVC.didMove(toParentViewController: self)
    }
    
    private func removeControllerInContauner() {
        self.controller?.willMove(toParentViewController: nil)
        self.controller?.view.removeFromSuperview()
        self.controller?.removeFromParentViewController()
    }
}
