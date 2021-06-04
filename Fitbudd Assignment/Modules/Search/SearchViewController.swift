//
//  SearchViewController.swift
//  Foody CookBook
//
//  Created by Shubham Arora on 11/05/21.
//

import UIKit

class SearchViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var tableView: SearchTableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Variables
    private var pageNumber: Int = 1
    private lazy var fullScreenSlideContainer: SlideContainer = {
        let slideContainer = SlideContainer()
        slideContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(slideTapped(_:))))
        slideContainer.enableTab = false
        slideContainer.backgroundColor = UIColor.black
        slideContainer.imageView.contentMode = .scaleAspectFit
        view.addSubview(slideContainer)
        return slideContainer
    }()
    
    private lazy var resultCollectionView: SearchCollectionView = {
        let collectionView = SearchCollectionView()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        view.addSubview(collectionView)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    /// Setting up slider frame
    /// - Parameters:
    ///   - images: Search Images
    ///   - index: Current Index
    private func setUpFullScreenSliderFrame(slides: [Slide], index: Int) {
        fullScreenSlideContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fullScreenSlideContainer.topAnchor.constraint(equalTo: view.topAnchor),
            fullScreenSlideContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            fullScreenSlideContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullScreenSlideContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        fullScreenSlideContainer.currentSlideIndex = index
        fullScreenSlideContainer.slides = slides
    }
    
    /// Setting up result collection view constaint
    private func setUpResultCollectionViewConstraint() {
        resultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultCollectionView.topAnchor.constraint(equalTo: tableView.topAnchor),
            resultCollectionView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            resultCollectionView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            resultCollectionView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
    }
    
    /// Setting up view
    private func setUpView() {
        searchBar.delegate = self
        searchBar.searchTextField.placeholder = "Search by name"
        setUpResultCollectionViewConstraint()
        tableView.searchFromRecentSearch = { [weak self] searchText in
            self?.pageNumber = 1
            self?.searchBar.text = searchText
            self?.resultCollectionView.imagesData = []
            self?.resultCollectionView.restore()
            self?.showResultsCollectionView()
            self?.searchImages(searchedText: searchText)
        }
        tableView.setEmptyMessage("Search for images")
        resultCollectionView.loadMoreData = { [weak self] _ in
            self?.checkForMoreData()
        }
    }
    
    /// Showing slides of images
    /// - Parameters:
    ///   - images: Search Images
    ///   - index: Current Index
    private func showLargeImages(images: [Slide], index: Int) {
        fullScreenSlideContainer.isHidden = false
        setUpFullScreenSliderFrame(slides: images, index: index)
    }
    
    /// Checking for more data
    private func checkForMoreData() {
        if resultCollectionView.imageResponseData.totalItems > resultCollectionView.imagesData.count {
            pageNumber += 1
            searchImages(searchedText: searchBar.text ?? "")
        }
    }
    
    /// Show results collection view
    private func showResultsCollectionView() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.resultCollectionView.isHidden = false
        }, completion: nil)
    }
    
    /// Hide results collection view
    private func hideResultsCollectionView() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.resultCollectionView.isHidden = true
        }, completion: nil)
    }
    
    // MARK: IBActions
    @IBAction func slideTapped(_ sender: UITapGestureRecognizer) {
        fullScreenSlideContainer.isHidden = true
    }
}

// MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            pageNumber = 1
            resultCollectionView.imagesData = []
            resultCollectionView.restore()
            showResultsCollectionView()
            searchBar.showsCancelButton = false
            searchImages(searchedText: searchText)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            hideResultsCollectionView()
            if tableView.recentSearches.count == 0 {
                tableView.setEmptyMessage("Search for images")
            } else {
                tableView.restore()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        hideResultsCollectionView()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
}

// MARK: Request Generator
extension SearchViewController: RequestGeneratorProtocol {
    
    private func searchImages(searchedText: String) {
        
        guard let url = URL(string: completeUrl(endpoint: .searchImages(searchedText, pageNumber)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
        SearchWebService.shared.searchImages(url: url) { [weak self] (response, msg, error) in
            
            guard let strongSelf = self else { return }
            if let response = response {
                if response.totalItems == 0 {
                    strongSelf.resultCollectionView.setEmptyMessage("Nothing here!")
                    strongSelf.resultCollectionView.imagesData = []
                    strongSelf.resultCollectionView.reloadData()
                } else {
                    if strongSelf.pageNumber == 1 {
                        if !strongSelf.tableView.recentSearches.contains(searchedText) {
                            strongSelf.tableView.recentSearches.insert(searchedText, at: 0)
                        }
                    }
                    strongSelf.resultCollectionView.restore()
                    strongSelf.resultCollectionView.imageResponseData = response
                }
            } else if let err = error {
                strongSelf.view.endEditing(true)
                strongSelf.view.makeToast(err.localizedDescription)
            } else {
                strongSelf.view.endEditing(true)
                strongSelf.view.makeToast("Something went wrong.")
            }
        }
    }
}
