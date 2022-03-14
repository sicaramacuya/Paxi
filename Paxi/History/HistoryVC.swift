//
//  HistoryVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit
import FSCalendar

class HistoryVC: UIViewController {
    
    // MARK: Properties
    fileprivate weak var calendar: FSCalendar!
    lazy var vcTintColor: UIColor = .systemOrange
    lazy var buttonSize: CGSize = CGSize(width: 60, height: 60)
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 75
        
        return table
    }()
    lazy var paymentsForSelectedDay: [Rent] = getPaymentsOnSpecific(date: calendar.today!) {
        didSet {
            tableView.reloadData()
        }
    }
    lazy var paymentSelected: Rent? = nil
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.title = "History"
        
        setupNavigationController()
        setupCalendar()
        setupTableView()
    }
    
    // MARK: Methods
    func setupNavigationController() {
        // add search button
        let searchButtonBarItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                        style: .plain, target: self, action: #selector(searchButtonSelected))
        let plusButtonBarItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                        style: .plain, target: self, action: #selector(addButtonSelected))
        
        self.navigationItem.rightBarButtonItems = [plusButtonBarItem, searchButtonBarItem]
        //self.navigationItem.rightBarButtonItem = searchButtonBarItem
        
        // style title
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let titleTextAttribute: [NSAttributedString.Key : Any] = [ .foregroundColor: UIColor.clear,]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute
        
        // add color
        self.navigationController?.navigationBar.tintColor = vcTintColor
    }
    
    func setupCalendar() {
        // Instantiating FSCalendar
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.backgroundColor = .secondarySystemBackground
        calendar.layer.cornerRadius = self.view.frame.width / 30
        calendar.clipsToBounds = true
        
        // Changing properties
        calendar.translatesAutoresizingMaskIntoConstraints = false
        //calendar.locale = .init(identifier: "es")
        
        
        // Changing it appearance
        calendar.appearance.headerTitleColor = vcTintColor
        calendar.appearance.weekdayTextColor = vcTintColor
        calendar.appearance.todayColor = vcTintColor
        calendar.appearance.todaySelectionColor = vcTintColor
        calendar.appearance.titleDefaultColor = UIColor(named: "TitleTextColor")
        calendar.appearance.titleSelectionColor = UIColor(named: "CalendarTitleSelection")
        calendar.appearance.selectionColor = UIColor(named: "TitleTextColor") // black/white
        calendar.appearance.eventDefaultColor = vcTintColor
        calendar.appearance.eventSelectionColor = vcTintColor
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 16, weight: .semibold)
        calendar.appearance.weekdayFont = .systemFont(ofSize: 13.5, weight: .medium)
        calendar.appearance.titleFont = .systemFont(ofSize: 13.5, weight: .regular)
        
        
        // Communicating who is the listener
        calendar.dataSource = self
        calendar.delegate = self
        
        // Adding View to Hierarchy
        self.view.addSubview(calendar)
        
        // Constraints
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            calendar.widthAnchor.constraint(equalTo: self.view.layoutMarginsGuide.widthAnchor),
            calendar.heightAnchor.constraint(equalTo: calendar.widthAnchor)
        ])
        
        // Saving calendar
        self.calendar = calendar
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        // registering a cell
        tableView.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: calendar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func getPaymentsOnSpecific(date: Date) -> [Rent] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetch = Rent.fetchRequest()
        
        // Fetching the payments that match the date selected.
        fetch.predicate = NSPredicate(format: "datePayment == %@", date as NSDate)
        
        // Sorting the payments on that date by name.
        let dateSortDescriptor = NSSortDescriptor(key: "payment", ascending: false)
        fetch.sortDescriptors = [dateSortDescriptor] // TODO: Sort by name
        
        let results = try! context.fetch(fetch)
        
        return results
    }
    
    func manageTableViewCellSelection(indexPath: IndexPath) {
        
        paymentSelected = paymentsForSelectedDay[indexPath.item]
        guard let property = paymentSelected?.tenant?.unit?.property else { return }
        guard let unit = paymentSelected?.tenant?.unit else { return }
        guard let tenant = paymentSelected?.tenant else { return }
        
        
        let paymentVC = PaymentVC()
        paymentVC.titleView.mainLabel.text = "Payment"
        paymentVC.titleView.mainLabel.textColor = vcTintColor
        paymentVC.titleView.cancelButton.isHidden = true
        paymentVC.titleView.checkMarkButton.isHidden = true
        paymentVC.rentTicketView.isHidden = true
        paymentVC.vcTintColor = .systemOrange
        
        navigationController?.present(paymentVC, animated: true)
        
        // Populating Fields
        paymentVC.formView.propertyTextField.text = property.title
        paymentVC.formView.unitTextField.text = unit.title
        paymentVC.formView.tenantTextField.text = tenant.name
        paymentVC.formView.rentTextField.text = String(paymentSelected!.rent)
        paymentVC.formView.paymentTextField.text = String(paymentSelected!.payment)
        paymentVC.formView.dateTextField.text = paymentSelected!.datePayment!.formatted(date: .long, time: .omitted)
        paymentVC.formView.noteTextField.text = paymentSelected?.note ?? ""
        
        // Disabling Fields
        paymentVC.formView.propertyTextField.isEnabled = false
        paymentVC.formView.unitTextField.isEnabled = false
        paymentVC.formView.tenantTextField.isEnabled = false
        paymentVC.formView.rentTextField.isEnabled = false
        paymentVC.formView.paymentTextField.isEnabled = false
        paymentVC.formView.dateTextField.isEnabled = false
        paymentVC.formView.noteTextField.isEnabled = false
    }
    
    @objc func addButtonSelected() {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let titleSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        // Property
        let fetchProperty = Property.fetchRequest()
        fetchProperty.sortDescriptors = [titleSortDescriptor]
        let resultsProperty = try! context.fetch(fetchProperty)
        
        // Unit
        let fetchUnit = Unit.fetchRequest()
        fetchUnit.sortDescriptors = [titleSortDescriptor]
        let resultUnit = try! context.fetch(fetchUnit)
        
        // Tenant
        let fetchTenat = Tenant.fetchRequest()
        fetchTenat.sortDescriptors = [nameSortDescriptor]
        let resultTenant = try! context.fetch(fetchTenat)
        
        
        let paymentVC = PaymentVC()
        paymentVC.propertyContent = resultsProperty
        paymentVC.unitContent = resultUnit
        paymentVC.tenantContent = resultTenant
        paymentVC.vcTintColor = .systemOrange
        
        paymentVC.modalPresentationStyle = .fullScreen
        navigationController?.present(paymentVC, animated: true)
    }
    
    @objc func searchButtonSelected() {
        let historySearchVC = HistorySearchVC()
        
        navigationController?.pushViewController(historySearchVC, animated: true)
    }
}

// MARK: FSCalendar Protocols
extension HistoryVC: FSCalendarDataSource, FSCalendarDelegate {
    // MARK: DataSource
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let paymentsOnGivenDate = getPaymentsOnSpecific(date: date)
        
        return paymentsOnGivenDate.count
    }
    
    // MARK: Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.paymentsForSelectedDay = getPaymentsOnSpecific(date: date)
    }
}

// MARK: TableView Protocols
extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentsForSelectedDay.count
    }
    
    // MARK: Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        
        let payment = self.paymentsForSelectedDay[indexPath.row]
        cell.nameLabel.text = payment.tenant?.name
        cell.paymentLabel.text = String(payment.payment)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        manageTableViewCellSelection(indexPath: indexPath)
    }
}
