//
//  LoginPasswordView.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 11.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//
//  типы контроллеров
//  кастом контейнер контроллера
//  top bar - 2 tab

import UIKit

protocol ButtonConnectDelegate: class {
    func actionButtonToConnect(login: String, password: String)
}

private enum StateInterface {
    case land
    case port
}

class LoginPasswordView: UIView {
    weak var delegate: ButtonConnectDelegate?
    private var constraintPort: [NSLayoutConstraint]?
    private var constraintLand: [NSLayoutConstraint]?
    private var stateApp: StateInterface?
    @IBOutlet private weak var firstText: UITextField!
    @IBOutlet private weak var secondText: UITextField!
    @IBOutlet private weak var button: UIButton!
    @IBAction func buttonOK(_ sender: Any) {
        delegate?.actionButtonToConnect(login: firstText.text!, password: secondText.text!)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        firstText.translatesAutoresizingMaskIntoConstraints = false
        secondText.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        secondText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        secondText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        constraintPort = [(secondText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)),
                          (secondText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)),
                          (firstText.bottomAnchor.constraint(equalTo: secondText.topAnchor, constant: -8)),
                          (firstText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)),
                          (firstText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)),
                          (button.topAnchor.constraint(equalTo: secondText.bottomAnchor, constant: 8)),
                          (button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50)),
                          (button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50))]
        
        constraintLand = [(secondText.leadingAnchor.constraint(equalTo: firstText.trailingAnchor, constant: 8)),
                          (firstText.centerYAnchor.constraint(equalTo: self.centerYAnchor)),
                          (button.centerYAnchor.constraint(equalTo: self.centerYAnchor)),
                          (button.leadingAnchor.constraint(equalTo: secondText.trailingAnchor, constant: 8)),
                          (firstText.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.28)),
                          (secondText.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.28)),
                          (button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2))]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.frame.width < self.frame.height {
            stateApp = .port
        } else {
            stateApp = .land
        }
        self.updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if stateApp == .port {
            constraintPort?.forEach { $0.isActive = true }
            constraintLand?.forEach { $0.isActive = false }
        } else if stateApp == .land{
            constraintPort?.forEach { $0.isActive = false }
            constraintLand?.forEach { $0.isActive = true }
        }
    }
}
