//
//  LoadComtroller.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 09.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class LoadController: UIViewController {
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    override func loadView() {
        let viewStart = UIView()
        self.view = viewStart
        viewStart.backgroundColor = .red
        
        print("loadView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
