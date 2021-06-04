//
//  SearchTableView.swift
//  Foody CookBook
//
//  Created by Shubham Arora on 11/05/21.
//

import UIKit

class SearchTableView: UITableView {

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
    private var slides: [Slide] = [Slide]()
    internal var selectImage: (([Slide], Int) -> Void)?
    internal var loadMoreData: ((Bool) -> Void)?
    internal var recentSearches: [String] = [String]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        // Register cell
        registerCell()
        tableFooterView = UIView.init(frame: .zero)
    }
    
    /// Registering cells
    private func registerCell() {
        register(cellType: SearchTableViewCell.self)
        register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func createSlides(didSelectIndex: Int) {
        slides = []
        for data in imagesData {
            slides.append(Slide(name: data.user, image: data.userImageURL))
        }
        selectImage?(slides, didSelectIndex)
    }
    
    private func showSearchTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= imagesData.count - 1 {
            loadMoreData?(true)
        }
        let cell = dequeueReusableCell(with: SearchTableViewCell.self, for: indexPath)
        cell.imageData = imagesData[indexPath.row]
        return cell
    }
}

// MARK: TableView Methods
extension SearchTableView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return recentSearches.count > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recentSearches.count > 0 {
            if section == 0 {
                return recentSearches.count
            } else {
                return imagesData.count
            }
        }
        return imagesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recentSearches.count > 0 {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.selectionStyle = .none
                cell.textLabel?.text = recentSearches[indexPath.row]
                return cell
            } else {
                return showSearchTableViewCell(indexPath: indexPath)
            }
        } else {
            return showSearchTableViewCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if recentSearches.count > 0 {
            if indexPath.section == 1 {
                createSlides(didSelectIndex: indexPath.row)
            }
        } else {
            createSlides(didSelectIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView = UIView.init()
            let shadowLabel: UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 9, width: tableView.bounds.size.width * 0.3, height: 1))
            shadowLabel.center.x = self.center.x
            shadowLabel.backgroundColor = UIColor.gray
            footerView.backgroundColor = UIColor.clear
            footerView.addSubview(shadowLabel)
            return footerView
        }
        return UIView(frame: .zero)
    }
}
