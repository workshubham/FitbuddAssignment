//
//  SearchTableView.swift
//  Foody CookBook
//
//  Created by Shubham Arora on 11/05/21.
//

import UIKit

class SearchTableView: UITableView {

    // Variables
    internal var recentSearches: [String] = [String]() {
        didSet {
            if recentSearches.count == 10 {
                recentSearches.removeLast()
            }
            reloadData()
        }
    }
    internal var searchFromRecentSearch: ((String) -> Void)?
    
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
    
    private func showSearchTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(with: SearchTableViewCell.self, for: indexPath)
        cell.lblName.text = recentSearches[indexPath.row]
        return cell
    }
}

// MARK: TableView Methods
extension SearchTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return showSearchTableViewCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchFromRecentSearch?(recentSearches[indexPath.row])
    }
}
