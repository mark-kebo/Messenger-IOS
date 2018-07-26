//
//  SessionProtocol.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 26.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

protocol SessionProtocol {
    func downloadImage(url: [URL], setImage: @escaping (UIImage) -> Void)
}
