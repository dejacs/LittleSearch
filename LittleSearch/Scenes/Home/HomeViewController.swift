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
    func display(searchResults: [SearchItem])
    func display(totalResults: Int)
}

final class HomeViewController: UIViewController {
    private enum Layout {
        enum StackView {
            static let layoutSpacing: CGFloat = 16
            static let layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
        
        enum ButtonNext {
            static let title = "Próxima Tela"
            static let height: CGFloat = 48
        }
        
        enum Table {
            static let height: CGFloat = 70
        }
    }
    
    private lazy var loadingView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .large)
        }
        return UIActivityIndicatorView(style: .medium)
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Layout.StackView.layoutSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Layout.StackView.layoutMargins
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var totalResultsLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var searchResultTable: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultViewCell.self, forCellReuseIdentifier: SearchResultViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var dataSource: [SearchItem] = []
    
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
        view.addSubview(stackView)
        stackView.addArrangedSubview(totalResultsLabel)
        stackView.addArrangedSubview(searchResultTable)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        loadingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        totalResultsLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        searchResultTable.snp.makeConstraints {
            $0.top.equalTo(totalResultsLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureViews() {
        title = "Resultados"
        navigationController?.navigationBar.backgroundColor = UIColor(named: "clr_branding")
        navigationController?.navigationBar.barTintColor = UIColor(named: "clr_branding")
        view.backgroundColor = .white
        stackView.backgroundColor = .clear
        setupSearchBar()
    }
}

private extension HomeViewController {
    func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar no Mercado Livre"
        searchController.searchBar.backgroundColor = UIColor(named: "clr_branding")
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        interactor.search(by: searchText)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.didSelect(productId: dataSource[indexPath.row].id)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !dataSource.isEmpty else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultViewCell.identifier) as! SearchResultViewCell
        cell.setup(dataSource[indexPath.row])
        return cell
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
    
    func display(searchResults: [SearchItem]) {
        searchResultTable.isHidden = false
        dataSource = searchResults
        searchResultTable.reloadData()
    }
    
    func display(totalResults: Int) {
        totalResultsLabel.text = totalResults.description + " resultados"
    }
}
