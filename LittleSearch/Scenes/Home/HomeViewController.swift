//
//  HomeViewController.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import SnapKit
import UIKit

protocol HomeDisplaying: AnyObject {
    func startLoading()
    func stopLoading()
    func display(totalResults: Int)
    func display(searchDataSource: [SearchItemResponse])
}

final class HomeViewController: UIViewController {
    private enum Layout {
        enum StackView {
            static let layoutSpacing: CGFloat = 16
            static let layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
    }
    
    private lazy var loadingView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .large)
        }
        return UIActivityIndicatorView(style: .medium)
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var searchResultTable: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultViewCell.self, forCellReuseIdentifier: SearchResultViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var searchDataSource: [SearchItemResponse] = []
    private var totalResults: Int = 0
    
    private let interactor: HomeInteracting
    
    init(interactor: HomeInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
}

extension HomeViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(loadingView)
        view.addSubview(searchResultTable)
    }
    
    func setupConstraints() {
        searchResultTable.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        loadingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configureViews() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: Strings.Color.branding)
        navigationController?.navigationBar.barTintColor = UIColor(named: Strings.Color.branding)
        view.backgroundColor = .white
        setupSearchBar()
    }
}

private extension HomeViewController {
    func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Strings.Placeholder.search
        searchController.searchBar.backgroundColor = UIColor(named: Strings.Color.branding)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func shouldLoadPage() -> Bool {
        return totalResults > searchDataSource.count
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        interactor.search(by: searchText)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.didSelect(searchItem: searchDataSource[indexPath.row])
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchDataSource.endIndex - 1 == indexPath.row, shouldLoadPage() {
            interactor.search(by: nil)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultViewCell.identifier) as! SearchResultViewCell
        cell.setup(searchDataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SearchResultViewHeader()
        view.display(totalResults: totalResults)
        return view
    }
}

extension HomeViewController: HomeDisplaying {
    func startLoading() {
        view.bringSubviewToFront(loadingView)
        searchResultTable.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func stopLoading() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    
    func display(totalResults: Int) {
        self.totalResults = totalResults
    }
    
    func display(searchDataSource: [SearchItemResponse]) {
        searchResultTable.isHidden = false
        self.searchDataSource = searchDataSource
        searchResultTable.reloadData()
    }
}
