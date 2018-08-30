//
//  CacheProtocol.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 31.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

protocol CacheProtocol {
    func addImageToCache (key: NSString, object: UIImage)
    func checkImageInCache(key: NSString) -> UIImage?
}
