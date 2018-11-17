//
//  PhotoListCellViewModel.swift
//  UberTest
//
//  Created by Anurag on 16/11/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

import UIKit

class PhotoListCellViewModel {
    var thumbnailImageURL: String = ""
    
    weak var photoListViewModel: PhotoListViewModel?
    var task: URLSessionDataTask?

    
    func loadImage(completion: @escaping (_ img: UIImage) -> ()) {
        guard let listVM = photoListViewModel else {
            return
        }
        let request = URLRequest(url: URL(string: thumbnailImageURL)!)
        if let image = listVM.cache.object(forKey: request as AnyObject) as? UIImage {
            completion(image)
        } else {
            task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    completion(image)
                    listVM.cache.setObject(image, forKey: request as AnyObject)
                }
            })
            task?.resume()
        }
    }
}
