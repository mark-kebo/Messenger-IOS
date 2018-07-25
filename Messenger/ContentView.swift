//
//  ContentView.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 18.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class ContentView: UIView {
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5)
        self.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        self.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        self.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
    }
}
