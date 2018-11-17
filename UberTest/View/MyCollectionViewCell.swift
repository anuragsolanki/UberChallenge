//
//  MyCollectionViewCell.swift
//  UberTest
//
//  Created by Anurag on 16/11/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    weak var cellVM: PhotoListCellViewModel?

    func initializeWithVM(cellViewModel: PhotoListCellViewModel) {
        cellVM = cellViewModel
        cellVM?.loadImage(completion: { (image) in
            DispatchQueue.main.async { [weak self] in
                self?.thumbnail.image = image
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnail.image = nil
        cellVM?.task?.cancel()
    }
    
}
