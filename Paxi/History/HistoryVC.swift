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
    lazy var formatter: DateFormatter = DateFormatter()
    lazy var vcTintColor: UIColor = .systemOrange
    lazy var buttonSize: CGSize = CGSize(width: 60, height: 60)
    lazy var addButton: UIButton = HistoryAddButtonView(buttonSize: buttonSize, vcTintColor: vcTintColor)
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setupNavigationController()
        setupCalendar()
        setupTableView()
        setupPlusButton()
    }
    
    // MARK: Methods
    func setupNavigationController() {
        // add search button
        let searchButtonBarItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                        style: .plain, target: self, action: #selector(searchButtonSelected))
        //let plusButtonBarItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
        //                style: .plain, target: self, action: #selector(addButtonSelected))
        
        //self.navigationItem.rightBarButtonItems = [plusButtonBarItem, searchButtonBarItem]
        self.navigationItem.rightBarButtonItem = searchButtonBarItem
        
        // style title
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let titleTextAttribute: [NSAttributedString.Key : Any] = [ .foregroundColor: UIColor.clear,]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute
        
        // add color
        self.navigationController?.navigationBar.tintColor = vcTintColor
    }
    
    func setupPlusButton() {
        self.view.addSubview(addButton)
        
        let buffer: CGFloat = 20
        addButton.frame = CGRect(x: self.view.frame.size.width - buttonSize.width - buffer,
                                 y: self.view.frame.size.height - buttonSize.height - buffer,
                                 width: buttonSize.width, height: buttonSize.height)
        
        addButton.addTarget(self, action: #selector(addButtonSelected), for: .touchUpInside)
    }
    
    func setupCalendar() {
        // Instantiating FSCalendar
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        
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
        
        // Communicating who is the listener
        calendar.dataSource = self
        calendar.delegate = self
        
        // Adding View to Hierarchy
        self.view.addSubview(calendar)
        
        // Constraints
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            calendar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            calendar.heightAnchor.constraint(equalTo: calendar.widthAnchor)
        ])
        
        // Saving calendar
        self.calendar = calendar
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: calendar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc func addButtonSelected() {
        let alert = UIAlertController(title: "Add Something", message: "Add button has been tapped.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc func searchButtonSelected() {
        let alert = UIAlertController(title: "Search Something", message: "Search button has been tapped.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
}

// MARK: FSCalendar Protocols
extension HistoryVC: FSCalendarDataSource, FSCalendarDelegate {
    // MARK: DataSource
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        formatter.dateStyle = .long
        
        guard let eventDate = formatter.date(from: "January 05, 2022") else { return 0 }
        if date.compare(eventDate) == .orderedSame {
            return 3
        }
        
        return 0
    }
    
    // MARK: Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateStyle = .long
        
        let dateSelected = formatter.string(from: date)
        let alert = UIAlertController(title: "Date Selected", message: "\(dateSelected)", preferredStyle: .alert)
        present(alert, animated: true) {
            // Dismiss alert after 1.5 seconds automatically.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: TableView Protocols
extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // MARK: Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let label = UILabel()
        label.text = "Hello World!"
        label.textAlignment = .center
        
        cell.backgroundView = label
        cell.backgroundView?.backgroundColor = .systemOrange
        
        return cell
    }
}
