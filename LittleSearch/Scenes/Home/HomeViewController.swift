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
    func display(searchResponse: SearchResponse)
    func displaySearchResponse(shouldDisplay: Bool)
    func displayEmpty()
    func displayError()
    func hideEmpty()
    func hideError()
    func displayWelcome(shouldDisplay: Bool)
    func displayErrorCell()
    func startLoadingCell()
    func stopLoadingCell()
}

final class HomeViewController: UIViewController {
    private enum Layout {
        enum StackView {
            static let layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
    }
    
    private lazy var loadingView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .large)
        }
        return UIActivityIndicatorView(style: .medium)
    }()
    
    private lazy var welcomeView = WelcomeView()
    private lazy var emptyView: UIView = EmptyView()
    private lazy var errorView: UIView = {
        let view = ErrorView()
        view.delegate = self
        return view
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
        tableView.backgroundColor = UIColor(named: Strings.Color.primaryBackground)
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
        interactor.welcome()
    }
}

// MARK: - ViewConfiguration
extension HomeViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(loadingView)
        view.addSubview(searchResultTable)
        view.addSubview(welcomeView)
    }
    
    func setupConstraints() {
        searchResultTable.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        welcomeView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configureViews() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: Strings.Color.branding)
        navigationController?.navigationBar.barTintColor = UIColor(named: Strings.Color.branding)
        view.backgroundColor = UIColor(named: Strings.Color.branding)
        setupSearchBar()
    }
}

// MARK: - Private methods
private extension HomeViewController {
    func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Strings.Placeholder.search
        searchController.searchBar.backgroundColor = UIColor(named: Strings.Color.branding)
        searchController.searchBar.delegate = self
        
        if
            let searchBarContainer = searchController.searchBar.subviews.first?.subviews[1],
            let textField = searchBarContainer.subviews.first(where: { view in view is UITextField })
        {
            textField.tintColor = UIColor(named: Strings.Color.tertiaryText)
            textField.backgroundColor = UIColor(named: Strings.Color.primaryBackground)
            textField.layer.cornerRadius = LayoutDefaults.CornerRadius.base00
            textField.layer.masksToBounds = true
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func shouldLoadNextPage(row: Int) -> Bool {
        row == searchDataSource.endIndex - 1 &&
        totalResults > searchDataSource.count
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchDataSource = []
        interactor.search(by: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        interactor.welcome()
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.didSelect(searchItem: searchDataSource[indexPath.row])
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultViewCell.identifier) as? SearchResultViewCell
        else {
            return UITableViewCell()
        }
        cell.setup(searchDataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SearchResultViewHeader()
        view.display(totalResults: totalResults)
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard shouldLoadNextPage(row: indexPath.row) else { return }
        interactor.loadNextPage()
    }
}

// MARK: - HomeDisplaying
extension HomeViewController: HomeDisplaying {
    func startLoading() {
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        loadingView.isHidden = false
        
        loadingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        loadingView.startAnimating()
    }
    
    func stopLoading() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
        loadingView.removeFromSuperview()
    }
    
    func display(searchResponse: SearchResponse) {
        totalResults = searchResponse.totalResults
        searchDataSource.append(contentsOf: searchResponse.results)
        searchResultTable.reloadData()
    }
    
    func displaySearchResponse(shouldDisplay: Bool) {
        searchResultTable.isHidden = !shouldDisplay
    }
    
    func displayEmpty() {
        view.addSubview(emptyView)
        view.bringSubviewToFront(emptyView)
        emptyView.isHidden = false
        
        emptyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func displayError() {
        view.addSubview(errorView)
        view.bringSubviewToFront(errorView)
        errorView.isHidden = false
        
        errorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func hideEmpty() {
        emptyView.isHidden = true
        emptyView.removeFromSuperview()
    }
    
    func hideError() {
        errorView.isHidden = true
        errorView.removeFromSuperview()
    }
    
    func displayWelcome(shouldDisplay: Bool) {
        welcomeView.isHidden = !shouldDisplay
        shouldDisplay ? welcomeView.startTimer() : welcomeView.stopTimer()
    }
    
    func displayErrorCell() {
        let toastLabel = ViewHelpers.toastLabel(
            message: Strings.CommonMessage.loadError,
            font: .systemFont(ofSize: LayoutDefaults.FontSize.base00)
        )
        toastLabel.frame = CGRect(
            x: view.frame.size.width / 2 - 75,
            y: view.frame.size.height - 100,
            width: view.frame.size.width / 2,
            height: 50
        )
        toastLabel.layer.cornerRadius = toastLabel.frame.height / 2
        view.addSubview(toastLabel)
        
        ViewHelpers.addFadeAnimation(to: toastLabel)
    }
    
    func startLoadingCell() { }
    
    func stopLoadingCell() { }
}

// MARK: - ErrorViewDelegate
extension HomeViewController: ErrorViewDelegate {
    func didTapButton() {
        interactor.search(by: nil)
    }
}
