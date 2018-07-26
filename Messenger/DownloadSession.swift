//
//  DownloadSession.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 26.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

public class DownloadSession: SessionProtocol {
    func downloadImage(url: [URL], setImage: @escaping (UIImage) -> Void) {
        var image = UIImage()
        let session = URLSession(configuration: URLSessionConfiguration.default)
        url.forEach() {
            session.dataTask(with: $0) { (data, _, error) in
                if error == nil {
                    image = UIImage(data: data!)!
                } else {
                    print(error as! String)
                }
                setImage(image)
            }.resume()
        }
    }
}
