//
//  SearchCollectionView.swift
//  Fitbudd Assignment
//
//  Created by Shubham Arora on 04/06/21.
//

import UIKit

class SearchCollectionView: UICollectionView {

    // Variables
    internal var loadMoreData: ((Bool) -> Void)?
    private var slides: [Slide] = [Slide]()
    internal var selectImage: (([Slide], Int) -> Void)?
    internal var showRecentSearches: Bool = true
    internal var imagesData: [ImagesViewModel] = [ImagesViewModel]() {
        didSet {
            reloadData()
        }
    }
    internal var imageResponseData: ImageResponseModel! {
        didSet {
            for images in imageResponseData.images {
                imagesData.append(ImagesViewModel(data: images))
            }
        }
    }
    internal var showInGrid: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setting up table view
        setUpCollectionView()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout.init())
        // Setting up table view
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Setting up table view
        setUpCollectionView()
    }
    
    /// Creating images for slide
    /// - Parameter didSelectIndex: slide current index
    private func createSlides(didSelectIndex: Int) {
        slides = []
        for data in imagesData {
            slides.append(Slide(name: data.user, image: data.userImageURL))
        }
        selectImage?(slides, didSelectIndex)
    }
    
    /// Setting up table view
    private func setUpCollectionView() {
        delegate = self
        dataSource = self
        // Register cell
        registerCells()
    }
    
    /// Registeingr cell
    private func registerCells() {
        register(cellType: SearchCollectionViewCell.self)
    }
}

extension SearchCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SearchCollectionViewCell.self, for: indexPath)
        cell.imageData = imagesData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item >= imagesData.count - 1 {
            loadMoreData?(true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if showInGrid {
            return CGSize(width: 180, height: 180 )
        } else {
            return CGSize(width: frame.width, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        createSlides(didSelectIndex: indexPath.item)
    }
}
