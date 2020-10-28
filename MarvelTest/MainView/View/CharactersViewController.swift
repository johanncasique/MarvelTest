//
//  ViewController.swift
//  MarvelTest
//
//  Created by johann casique on 25/10/20.
//

import UIKit

class CharactersViewController: UIViewController {
    
    @Inject var viewModel: CharactersViewModelProtocol?
    lazy var tableViewController: PagedTableViewController = {
        let table = PagedTableViewController()
        table.view.translatesAutoresizingMaskIntoConstraints = false
        table.view.backgroundColor = .secondarySystemBackground
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel?.viewDidLoad()
    }
    
    private func setupViews() {
        view.addSubview(tableViewController.view)
        tableViewController.tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
        tableViewController.tableView.rowHeight = 120
        tableViewController.tableView.separatorStyle = .none
        tableViewController.pagedTableModel = self
        view.backgroundColor = .secondarySystemBackground
        title = "Marvel"
        
        NSLayoutConstraint.activate([
            tableViewController.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableViewController.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableViewController.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableViewController.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.bounds.height + targetContentOffset.pointee.y > max(scrollView.bounds.height, scrollView.contentSize.height - 100) {
            tableViewController.refresh()
        }
    }
}

extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfrows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureView(with: viewModel?.getModel(from: indexPath))
        
        return cell
    }
}

extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelecteditem(at: indexPath)
    }
}

extension CharactersViewController: CharacterViewModelViewDelegate {
    func viewState(_ state: CharactersViewState) {
        switch state {
        case .loading:
            LoadingView.shared.show(view)
        case .showData:
            LoadingView.shared.hide()
            tableViewController.tableView.reloadData()
            tableViewController.refreshDidFinish()
        case .error: break
        case .emptyData: break
        }
    } 
}

extension CharactersViewController: PagedTableViewModel {
    func requestNewPage() {
        viewModel?.newPage()
    }
    
    func hasMoreData() -> Bool {
        return viewModel?.hasMoreData() ?? false
    }
}
