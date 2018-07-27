//
//  DownloadSession.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 26.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//
//  Сеансы:
//  Сеансы по умолчанию - хранят кэш и данные на диске
//  Эфемерные - не хранят в RAM, чистятся когда завершается сеанс.
//  Фоновые - отдельный процесс обрабатывает всю передачу данных.

//  Задачи:
//  Задачи данных отправляют и получают использование данных NSData объекты. Задачи данных могут возвратить данные Вашему приложению одна часть за один раз после того, как каждая часть данных будет получена, или одновременно через обработчик завершения. Поскольку задачи данных не хранят данные к файлу, они не поддерживаются в фоновых сеансах.
//  В то время как приложение не работает, задачи загрузки получают данные в форме файла и поддерживают фоновые загрузки.
//  В то время как приложение не работает, задачи загрузки отправляют данные (обычно в форме файла) и поддерживают фоновые загрузки.
//  URLSessionTask-Задача, как и загрузка определенного ресурса, выполняется в сеансе URL.
//  URLSessionDataTask-Задача сеанса URL, которая возвращает загруженные данные непосредственно в память.
//  URLSessionUploadTask-Задача сеанса URL, которая загружает данные в сеть в тело запроса.
//  URLSessionDownloadTask- сеанса URL, которая хранит загруженные данные в файле.

import UIKit

public class DownloaderImage: DownloaderImageProtocol {
    //  NSCache-временное хранение переходных пар ключ-значение(временное хранение объектов с временными данными)
    var cache: NSCache<NSString, UIImage>!
    
    init() {
        self.cache = NSCache()
    }
    
    func downloadImage(session: URLSession, imagePath: String, completionHandler: @escaping ImageCacheLoaderCompletionHandler) {
        //достал из кэша по ключу объект image что бы избежать повторного скачивание
        if let image = self.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            let url: URL! = URL(string: imagePath)
            session.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
                guard let data = data , error == nil, let img = UIImage(data: data) else { return }
                //убираю объект image в кэш с ключом
                self.cache.setObject(img, forKey: imagePath as NSString)
                DispatchQueue.main.async {
                    completionHandler(img)
                }
            }).resume()
        }
    }
}

//func downloadImage(session: URLSession, imagePath: String, completionHandler: @escaping ImageCacheLoaderCompletionHandler) {
//
//    if let image = self.cache.object(forKey: imagePath as NSString) {
//        DispatchQueue.main.async {
//            completionHandler(image)
//        }
//    } else {
//        let url: URL! = URL(string: imagePath)
//        session.dataTask(with: url, completionHandler: { (location, response, error) in
//              создает буфер данных по юрл-у (т/е/ берет данные по юрл и пишет их в экземпляр)
//            if let data = try? Data(contentsOf: url) {
//                let img: UIImage! = UIImage(data: data)
//                self.cache.setObject(img, forKey: imagePath as NSString)
//                DispatchQueue.main.async {
//                    completionHandler(img)
//                }
//            }
//        }).resume()
//    }
//}
