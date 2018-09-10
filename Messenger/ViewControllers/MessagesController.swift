//
//  SecondTab.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 18.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class MessagesController: UIViewController {
    private var provider: MessagesProviderProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provider = VKProvider()
        provider?.getMessagesList(treatmentMessages: { [weak self] (messages) in
            var i = 1
            messages.forEach {
                print($0)
                print("---\(i)----------------")
                i = i + 1
            }
        })
    }
}
