//
//  PagedTableViewController.swift
//  MarvelTest
//
//  Created by johann casique on 27/10/20.
//

import UIKit

protocol PagedTableViewModel {
    func requestNewPage()
    func hasMoreData() -> Bool
}

open class PagedTableViewController: UITableViewController {
    var page: Int = 1
    var pagedTableModel: PagedTableViewModel?
    var isRefreshing = false
    
    public lazy var loadingFooter: UIActivityIndicatorView = {
        let footer = UIActivityIndicatorView(style: .medium)
        footer.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 20))
        footer.hidesWhenStopped = true
        return footer
    }()
    
    open override func viewDidLoad() {
        setUpView()
    }
    
    private func setUpView() {
        self.tableView.tableFooterView = loadingFooter
    }
    
    public func refreshDidFinish() {
        isRefreshing = false
        loadingFooter.stopAnimating()
    }
    
    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return loadingFooter
    }

    open override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    public func refresh() {
        let hasMoreData = self.pagedTableModel?.hasMoreData() ?? false
        if hasMoreData && !isRefreshing {
            isRefreshing = true
            DispatchQueue.main.async {
                self.loadingFooter.startAnimating()
            }
            self.pagedTableModel?.requestNewPage()
        }
    }
}
