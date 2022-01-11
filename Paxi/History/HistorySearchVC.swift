//
//  HistorySearchVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

class HistorySearchVC: UIViewController {
    
    // MARK: Properties
    lazy var vcTintColor: UIColor = .systemOrange
    lazy var formatter: DateFormatter = DateFormatter()
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.tintColor = vcTintColor
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name", "Property", "Quantity", "Note"]
        searchBar.selectedScopeButtonIndex = 0
        
        return searchBar
    }()
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 75
        
        return table
    }()
    lazy var searchResult: [Payment] = getAllPayments() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
    
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setupSearchBar()
        setupTableView()
    }
    
    
    // MARK: Methods
    func setupSearchBar() {
        searchBar.delegate = self
        
        self.view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        // registering a cell
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func getAllPayments() -> [Payment] {
        let context = CDStack.shared.persistentContainer.viewContext
        let fetch = Payment.fetchRequest()
        
        // Sorting the payments on that date by name.
        let nameSortDescriptor = NSSortDescriptor(key: "tenant.name", ascending: true)
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetch.sortDescriptors = [nameSortDescriptor, dateSortDescriptor] // TODO: Sort by name
        
        let results = try! context.fetch(fetch)
        
        return results
    }
    
    func getPaymentsOnSpecific(searchText: String, selectedScopeButtonIndex: Int = 0) -> [Payment] {
        let context = CDStack.shared.persistentContainer.viewContext
        let fetch = Payment.fetchRequest()
        
        switch selectedScopeButtonIndex {
        case 1:
            // Fetching the payments that match the date selected.
            fetch.predicate = NSPredicate(format: "tenant.property.title CONTAINS[c] %@", searchText as NSString)
        case 2:
            // Fetching the payments that match the payment/quantity selected.
            fetch.predicate = NSPredicate(format: "payment CONTAINS[c] %@", searchText)
        case 3:
            // Fetching the payments that match the note selected.
            fetch.predicate = NSPredicate(format: "note CONTAINS[c] %@", searchText as NSString)
        default:
            // Fetching the payments that match the date selected.
            fetch.predicate = NSPredicate(format: "tenant.name CONTAINS[c] %@", searchText as NSString)
        }
        
        // Sorting the payments on that date by name.
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetch.sortDescriptors = [dateSortDescriptor] // TODO: Sort by name
        
        let results = try! context.fetch(fetch)
        
        return results
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {

        // dismiss keyboard for weight text field
        if searchBar.searchTextField.isEditing {
            searchBar.searchTextField.resignFirstResponder()
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
}

// MARK: SearchBar Protocols
extension HistorySearchVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
        if searchResult.isEmpty {
            self.searchResult = getAllPayments()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let selectedIndex = self.searchBar.selectedScopeButtonIndex
        self.searchResult = getPaymentsOnSpecific(searchText: searchText, selectedScopeButtonIndex: selectedIndex)
    }
}

// MARK: TableView Protocols
extension HistorySearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        
        let payment = searchResult[indexPath.item]
        cell.nameLabel.text = payment.tenant?.name
        formatter.dateStyle = .short
        cell.dateLabel.text = formatter.string(from: payment.date!)
        cell.paymentLabel.text = String(payment.payment)
        
        return cell
    }
    
    
}
