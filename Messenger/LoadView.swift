//
//  LoadView.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 11.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class LoadView: UIView {
    @IBOutlet var loadingView: UIView!
    @IBAction func ButtonOK(_ sender: Any) {
    }
    @IBAction func firstText(_ sender: Any) {
    }
    @IBAction func secondText(_ sender: Any) {
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
        //загрузка xib по имени
        Bundle.main.loadNibNamed("LoadView", owner: self, options: nil)
        //добавление вида
        addSubview(loadingView)
        //позиционирование вида
        loadingView.frame = self.bounds
        loadingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
