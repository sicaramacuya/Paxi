//
//  AgendaVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

class AgendaVC: UIViewController {
    
    // MARK: Properties
    lazy var vcTintColor: UIColor = .systemPurple
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        
        return table
    }()
    lazy var payments: [String] = [String](repeating: "Payment", count: 1)
    lazy var dueDate: [String] = ["01/05/22"]
    
    // MARK: VC's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        self.title = "Agenda"
        
        setupNavigationController()
        setupTableView()
    }
    
    
    // MARK: Methods
    func setupNavigationController() {
        // style title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let titleTextAttribute: [NSAttributedString.Key : Any] = [ .foregroundColor: UIColor.clear,]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute
        
        // add color
        self.navigationController?.navigationBar.tintColor = vcTintColor
    }
    
    func setupTableView() {
        // Add to view's herarchy
        self.view.addSubview(tableView)
        
        // Add listener to the tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // Registering cell
        tableView.register(AgendaCell.self, forCellReuseIdentifier: AgendaCell.identifier)
        
        // Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: TableView Protocols
extension AgendaVC: UITableViewDataSource {
    // MARK: TableViewDataSource
    
    //func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //    let view = UILabel()
    //    //view.backgroundColor = .systemPurple
    //    view.text = "Overdue"
    //
    //    return view
    //}
    
    //func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //    let view = UILabel()
    //    //view.backgroundColor = .systemPurple
    //    view.text = "Overdue"
    //
    //    return view
    //}
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Overdue", "Today", "Tomorrow", "Future Days"][section]
    }
    
    //func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //    return [44, 44][section]
    //}
    
    //func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    //    return "Footer"
    //}
    
    
    /*
    
     Every section needs to be a day for the payment. The first three sections are fixed: Overdue, Today and Tomorrow... In case there are payments for any of those days thats the title we are going to display.
     
     After those three sections ever consecutive section will a date when payment is due. This day the payment is due is going to be calculated by adding a month to its starting date.
    
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ["Overdue", "Today", "Tomorrow", "Future Days"].count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.identifier, for: indexPath) as! AgendaCell
        
        cell.nameLabel.text = "Tommy Ellis"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let formattedNumber = numberFormatter.string(from: NSNumber(value:500)) ?? ""
        cell.amountLabel.text = formattedNumber
        
        if indexPath.section == 0 {
            cell.dueDateFlagLable.text = dueDate[0]
            cell.backgroundDueDateFlag.backgroundColor = .systemRed
        } else {
            cell.backgroundDueDateFlag.isHidden = false
        }
        
        
        return cell
    }
}

extension AgendaVC: UITableViewDelegate {
    // MARK: TableViewDelegate
}
