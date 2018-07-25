//
//  LoginPasswordLandView.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 11.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class LoginPasswordLandView: UIView {
    private let nibName = "LoginPasswordLandView"
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var firstText: UITextField!
    @IBOutlet weak var secondText: UITextField!
    @IBAction func buttonOK(_ sender: Any) {
        print(firstText.text!)
        print(secondText.text!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        //грузим xib
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        //добавим вид в качестве подзаголовка
        addSubview(contentView)
        //позиционирование
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
