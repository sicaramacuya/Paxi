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
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetch = Payment.fetchRequest()
        
        // Sorting the payments on that date by name.
        let nameSortDescriptor = NSSortDescriptor(key: "tenant.name", ascending: true)
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetch.sortDescriptors = [nameSortDescriptor, dateSortDescriptor] // TODO: Sort by name
        
        let results = try! context.fetch(fetch)
        
        return results
    }
    
    func getPaymentsOnSpecific(searchText: String, selectedScopeButtonIndex: Int = 0) -> [Payment] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
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
    
    func manageTableViewCellSelection(indexPath: IndexPath) {
        
        let paymentSelected = searchResult[indexPath.item]
        guard let property = paymentSelected.tenant?.unit?.property else { return }
        guard let unit = paymentSelected.tenant?.unit else { return }
        guard let tenant = paymentSelected.tenant else { return }
        
        
        let paymentVC = PaymentVC()
        paymentVC.titleView.mainLabel.text = "Payment"
        paymentVC.titleView.mainLabel.textColor = vcTintColor
        paymentVC.titleView.cancelButton.isHidden = true
        paymentVC.titleView.checkMarkButton.isHidden = true
        paymentVC.vcTintColor = .systemOrange
        
        navigationController?.present(paymentVC, animated: true)
        
        // Populating Fields
        paymentVC.formView.propertyTextField.text = property.title
        paymentVC.formView.unitTextField.text = unit.title
        paymentVC.formView.tenantTextField.text = tenant.name
        paymentVC.formView.rentTextField.text = String(paymentSelected.rent)
        paymentVC.formView.paymentTextField.text = String(paymentSelected.payment)
        paymentVC.formView.dateTextField.text = paymentSelected.date!.formatted(date: .long, time: .omitted)
        paymentVC.formView.noteTextField.text = paymentSelected.note ?? ""
        
        // Disabling Fields
        paymentVC.formView.propertyTextField.isEnabled = false
        paymentVC.formView.unitTextField.isEnabled = false
        paymentVC.formView.tenantTextField.isEnabled = false
        paymentVC.formView.rentTextField.isEnabled = false
        paymentVC.formView.paymentTextField.isEnabled = false
        paymentVC.formView.dateTextField.isEnabled = false
        paymentVC.formView.noteTextField.isEnabled = false
    }
}

// MARK: SearchBar Protocols
extension HistorySearchVC: UISearchBarDelegate {
    // MARK: TableView Delegate
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
    // MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        
        let payment = searchResult[indexPath.item]
        cell.nameLabel.text = payment.tenant?.name
        cell.dateLabel.text = payment.date!.formatted(date: .numeric, time: .omitted)
        cell.paymentLabel.text = String(payment.payment)
        
        return cell
    }
    
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        manageTableViewCellSelection(indexPath: indexPath)
    }
}
