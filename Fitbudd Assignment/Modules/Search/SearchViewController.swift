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
    
    /// Setting up view
    private func setUpView() {
        searchBar.delegate = self
        searchBar.searchTextField.placeholder = "Search by name"
        tableView.selectImage = { [weak self] (images, index) in
            self?.showLargeImages(images: images, index: index)
        }
        tableView.loadMoreData = { [weak self] _ in
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
        if tableView.imageResponseData.totalItems > tableView.imagesData.count {
            pageNumber += 1
            searchImages(searchedText: searchBar.text ?? "")
        }
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
            tableView.imagesData = []
            searchImages(searchedText: searchText)
        }
        searchBar.resignFirstResponder()
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
                    strongSelf.tableView.setEmptyMessage("Nothing here!")
                    strongSelf.tableView.imagesData = []
                    strongSelf.tableView.reloadData()
                } else {
                    if strongSelf.pageNumber == 1 {
                        strongSelf.tableView.recentSearches.append(searchedText)
                    }
                    strongSelf.tableView.restore()
                    strongSelf.tableView.imageResponseData = response
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
