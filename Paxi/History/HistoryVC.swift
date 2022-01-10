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
    lazy var addButton: UIButton = HistoryAddButtonView(buttonSize: buttonSize, vcTintColor: vcTintColor)
    
    // MARK: VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setupPlusButton()
        setupNavigationController()
        setupCalendar()
    }
    
    // MARK: Methods
    func setupNavigationController() {
        // add search button
        let searchButtonBarItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                        style: .plain, target: self, action: #selector(searchButtonSelected))
        
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
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        // Changing it appearance
        calendar.appearance.headerTitleColor = vcTintColor
        calendar.appearance.weekdayTextColor = vcTintColor
        calendar.appearance.todayColor = vcTintColor
        calendar.appearance.todaySelectionColor = vcTintColor
        calendar.appearance.titleDefaultColor = UIColor(named: "TitleTextColor")
        calendar.appearance.titleSelectionColor = UIColor(named: "CalendarTitleSelection")
        calendar.appearance.selectionColor = UIColor(named: "TitleTextColor") // black/white
        
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
    
}
