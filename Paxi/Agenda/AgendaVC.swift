//
//  AgendaVC.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import UIKit

enum sectionCategory {
    case overdue
    case today
    case tomorrow
    case future
}

class AgendaVC: UIViewController {
    
    // MARK: Properties
    let context = CoreDataStack.shared.persistentContainer.viewContext
    lazy var vcTintColor: UIColor = .systemPurple
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        
        return table
    }()
    lazy var payments: [String] = [String](repeating: "Payment", count: 1)
    lazy var dueDate: [String] = ["01/05/22"]
    //lazy var allRentsToBePaid: [Rent] = getRentsThatNeedsToBePaid()
    lazy var overDueRents: [Rent] = sortRents(section: .overdue)
    lazy var todayRents: [Rent] = sortRents(section: .today)
    lazy var tomorrowRents: [Rent] = sortRents(section: .tomorrow)
    lazy var futureRents: [Rent] = sortRents(section: .future)
    
    
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
    
    func getRentsThatNeedsToBePaid() -> [Rent] {
        //let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetch = Rent.fetchRequest()
        
        fetch.predicate = NSPredicate(format: "isRentPaid == false")
        
        // Sorting the payments on that date by name.
        let nameSortDescriptor = NSSortDescriptor(key: "tenant.name", ascending: true)
        let dateSortDescriptor = NSSortDescriptor(key: "datePayment", ascending: true)
        fetch.sortDescriptors = [nameSortDescriptor, dateSortDescriptor] // TODO: Sort by name
        
        let results = try! context.fetch(fetch)
        
        return results
    }
    
    func getOverDueRents() -> [Rent] {
        let fetch = Rent.fetchRequest()
        
        let rentsThatNeedToBePaid = NSPredicate(format: "isRentPaid == false")
        let rentIsOverDue = NSPredicate(format: "dateRentIsDue < %@", Date.now as NSDate)
        
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [rentsThatNeedToBePaid, rentIsOverDue])
        fetch.predicate = predicate
        
        let nameSortDescriptor = NSSortDescriptor(key: "tenant.name", ascending: true)
        fetch.sortDescriptors = [nameSortDescriptor]
        
        let results = try! context.fetch(fetch)
        
        return results
    }
    
    func getTodayDueRents() -> [Rent] {
        let fetch = Rent.fetchRequest()
        
        // This is to get rid of the hours.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, y"
        let todayDateString = dateFormatter.string(from: Date.now)
        let todayDateWithOutTime = dateFormatter.date(from: todayDateString)
        
        let rentsThatNeedToBePaid = NSPredicate(format: "isRentPaid == false")
        let rentsForToday = NSPredicate(format: "dateRentIsDue == %@", todayDateWithOutTime! as NSDate)
        
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [rentsThatNeedToBePaid, rentsForToday])
        fetch.predicate = predicate
        
        let nameSortDescriptor = NSSortDescriptor(key: "tenant.name", ascending: true)
        fetch.sortDescriptors = [nameSortDescriptor]
        
        let results = try! context.fetch(fetch)
        
        return results
    }
    
    func getTomorrowDueRents() -> [Rent] {
        let fetch = Rent.fetchRequest()
        
        // This is to calculate tomorrows date.
        let oneday = DateComponents(calendar: .current, timeZone: .current, day: 1)
        let tomorrowDate = Calendar.current.date(byAdding: oneday, to: Date.now)
        
        // This is to get rid of the hour.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, y"
        let todayDateString = dateFormatter.string(from: tomorrowDate!)
        let todayDateWithOutTime = dateFormatter.date(from: todayDateString)
        
        
        let rentsThatNeedToBePaid = NSPredicate(format: "isRentPaid == false")
        let rentIsOverDue = NSPredicate(format: "dateRentIsDue == %@", todayDateWithOutTime! as NSDate)
        
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [rentsThatNeedToBePaid, rentIsOverDue])
        fetch.predicate = predicate
        
        let nameSortDescriptor = NSSortDescriptor(key: "tenant.name", ascending: true)
        fetch.sortDescriptors = [nameSortDescriptor]
        
        let results = try! context.fetch(fetch)
        
        return results
    }
    
    func getFutureDueRents() -> [Rent] {
        let fetch = Rent.fetchRequest()
        
        // This is to calculate tomorrows date.
        let oneday = DateComponents(calendar: .current, timeZone: .current, day: 1)
        let tomorrowDate = Calendar.current.date(byAdding: oneday, to: Date.now)
        
        // This is to get rid of the hour.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, y"
        let todayDateString = dateFormatter.string(from: tomorrowDate!)
        let todayDateWithOutTime = dateFormatter.date(from: todayDateString)
        
        
        let rentsThatNeedToBePaid = NSPredicate(format: "isRentPaid == false")
        let rentIsOverDue = NSPredicate(format: "dateRentIsDue > %@", todayDateWithOutTime! as NSDate)
        
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [rentsThatNeedToBePaid, rentIsOverDue])
        fetch.predicate = predicate
        
        let nameSortDescriptor = NSSortDescriptor(key: "tenant.name", ascending: true)
        fetch.sortDescriptors = [nameSortDescriptor]
        
        let results = try! context.fetch(fetch)
        
        return results
    }
    
    func sortRents(section: sectionCategory) -> [Rent] {
        switch section {
        case .overdue:
             return getOverDueRents()
        case .today:
            return getTodayDueRents()
        case .tomorrow:
            return getTomorrowDueRents()
        case .future:
            return getFutureDueRents()
        }
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
        
        let rowForSection = (overdue: overDueRents, today: todayRents, tomorrow: tomorrowRents, futureDays: futureRents)
        
        switch section {
        case 0:
            return rowForSection.overdue.count
        case 1:
            return rowForSection.today.count
        case 2:
            return rowForSection.tomorrow.count
        case 3:
            return rowForSection.futureDays.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.identifier, for: indexPath) as! AgendaCell
        
        //cell.nameLabel.text = "Tommy Ellis"
        //
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let formattedNumber = numberFormatter.string(from: NSNumber(value:500)) ?? ""
        cell.amountLabel.text = formattedNumber
        //
        if indexPath.section == 0 {
            cell.backgroundDueDateFlag.backgroundColor = .systemRed
        } else {
            cell.backgroundDueDateFlag.isHidden = false
        }
        //
        //return cell
        
        let rowForSection = (overdue: overDueRents, today: todayRents, tomorrow: tomorrowRents, futureDays: futureRents)
        
        switch indexPath.section {
        case 0:
            let rents = rowForSection.overdue
            cell.nameLabel.text = rents[indexPath.item].tenant!.name
            
            let rent = rents[indexPath.item].rent
            let formattedNumber = numberFormatter.string(from: NSNumber(value: rent)) ?? ""
            cell.amountLabel.text = formattedNumber
            
            cell.dueDateFlagLable.text = rents[indexPath.item].dateRentIsDue?.formatted(date: .numeric, time: .omitted)
            
        case 1:
            let rents = rowForSection.today
            cell.nameLabel.text = rents[indexPath.item].tenant!.name
            
            let rent = rents[indexPath.item].rent
            let formattedNumber = numberFormatter.string(from: NSNumber(value: rent)) ?? ""
            cell.amountLabel.text = formattedNumber
        case 2:
            let rents = rowForSection.tomorrow
            cell.nameLabel.text = rents[indexPath.item].tenant!.name
            
            let rent = rents[indexPath.item].rent
            let formattedNumber = numberFormatter.string(from: NSNumber(value: rent)) ?? ""
            cell.amountLabel.text = formattedNumber
        case 3:
            let rents = rowForSection.futureDays
            cell.nameLabel.text = rents[indexPath.item].tenant!.name
            
            let rent = rents[indexPath.item].rent
            let formattedNumber = numberFormatter.string(from: NSNumber(value: rent)) ?? ""
            cell.amountLabel.text = formattedNumber
        default:
            break
        }
        
        return cell
    }
}

extension AgendaVC: UITableViewDelegate {
    // MARK: TableViewDelegate
}
