//
//  PhotoListViewModel.swift
//  UberTest
//
//  Created by Anurag on 16/11/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

import Foundation
import UIKit

class PhotoListViewModel {
    
    let webHelper: WebServiceProtocol
    
    private var photos: [FlickrPhoto] = []
    var searchField = UISearchBar()
    var currentPage = 1
    var cache: NSCache<AnyObject, AnyObject>!

    
    private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }

    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    var reloadCollectionViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoaderWithNextRequest: ((_ startSpinner: Bool)->())?
    var searchTappedClosure:(()->())?


    init( apiService: WebServiceProtocol = WebHelper()) {
        self.webHelper = apiService
        self.cache = NSCache()
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( photo: FlickrPhoto ) -> PhotoListCellViewModel {
        let cellVM = PhotoListCellViewModel()
        cellVM.thumbnailImageURL = photo.thumbnailImageURL()
        cellVM.photoListViewModel = self
        return cellVM
    }
    
    private func processFetchedPhoto( photos: [FlickrPhoto] ) {
        self.photos = photos
        var vms = [PhotoListCellViewModel]()
        for photo in photos {
            vms.append( createCellViewModel(photo: photo) )
        }
        self.cellViewModels = vms
    }
    
    func searchTappedWith(searchText: String?) {
        if let txt = searchText {
            searchTappedClosure?()
            currentPage = 1
            searchForResultWith(text: txt)
        }
    }
    
    func searchForResultWith(text searchText: String) {
        webHelper.searchWithText(queryString: searchText, pageNo: "\(currentPage)", completion: { [weak self]
            (entries) in
            guard let _ = entries else {
                self?.alertMessage = "Oops! Something went wrong."
                return
            }
            if self?.currentPage == 1 {
                self?.photos = []
            }
            if let entry = entries {
                self?.photos.append(contentsOf: entry.photos!.flickrPhotos)
            }
            self?.processFetchedPhoto(photos: self!.photos)
        })
    }
    
    func supplementaryViewDisplayed(forText text: String?) {
        if photos.count > 0 {
            updateLoaderWithNextRequest?(true)
            if let searchText = text {
                currentPage = currentPage + 1
                searchForResultWith(text: searchText)
            }
        } else {
            updateLoaderWithNextRequest?(false)
        }
    }
    
    func itemSize() -> CGFloat {
        return (UIScreen.main.bounds.width-40)/3
    }
}
