//
//  ViewController.swift
//  UberTest
//
//  Created by Anurag on 16/11/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    lazy var viewModel: PhotoListViewModel = {
        return PhotoListViewModel()
    }()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var searchField = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.keyboardDismissMode = .interactive
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
    }
    
    func initView() {
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.searchBarStyle = .minimal
        searchField.delegate = self
        navigationItem.titleView = searchField
    }

    func initVM() {
        
        // Native binding using closures
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.updateLoaderWithNextRequest = { [weak self] (start) in
            let spinner = self?.view.viewWithTag(99) as? UIActivityIndicatorView
            if start {
                spinner?.startAnimating()
            } else {
                spinner?.stopAnimating()
            }
        }
        
        viewModel.searchTappedClosure = { [weak self] () in
            self?.searchField.resignFirstResponder()
            self?.collectionView.setContentOffset(CGPoint.zero, animated: false)
        }

    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

// MARK:- Search Bar Delegate Protocol Methods

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchTappedWith(searchText: searchField.text)
    }
}


// MARK: - UICollectionView protocols

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.CollectionView.cell, for: indexPath as IndexPath) as? MyCollectionViewCell else {
            fatalError("Cell doesn't exist in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.initializeWithVM(cellViewModel: cellVM)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = viewModel.itemSize()
        return CGSize(width: itemSize, height:itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath)
            return footerView
        default:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath)
            return footerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        viewModel.supplementaryViewDisplayed(forText: searchField.text)
    }
}
