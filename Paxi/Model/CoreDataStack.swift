//
//  CoreDataStack.swift
//  Paxi
//
//  Created by Eric Morales on 12/17/21.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Paxi")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension Property {
    var amount: Double {
        return allPayments.reduce(0) { sum, payment in
            return sum + payment.payment
        }
    }
    
    var allUnits: [Unit] {
        let result =  units?.allObjects as! [Unit]
        return result.sorted { $0.title! < $1.title! }
    }
    
    var allTenants: [Tenant] {
        let result = tenants?.allObjects as! [Tenant]
        return result.sorted { $0.name! < $1.name! }
    }
    
    var allPayments: [Rent] {
        return payments?.allObjects as! [Rent]
    }
}

extension Unit {
    var amount: Double {
        return allPayments.reduce(0) { sum, payment in
            return sum + payment.payment
        }
    }
    
    var allTenants: [Tenant] {
        return tenants?.allObjects as! [Tenant]
    }
    
    var allPayments: [Rent] {
        return payments?.allObjects as! [Rent]
    }
}

extension Tenant {
    var amount: Double {
        return allPayments.reduce(0) { sum, payment in
            return sum + payment.payment
        }
    }
    
    var allPayments: [Rent] {
        
        let rents = payments?.allObjects as! [Rent]
        var rentsPaid: [Rent] = []
        
        for rent in rents {
            if rent.isRentPaid {
                rentsPaid.append(rent)
            }
        }
        
        return rentsPaid
    }
    
    var ticketNumber: Int {
        return self.allPayments.count + 1
    }
    
    var rentToPay: Rent {
        let rents = payments?.allObjects as! [Rent]
        let lastRent: Rent? = rents.last { rent in
            return !rent.isRentPaid
        }
        
        return lastRent!
    }
    
    func createNextMonthRent(dateOfRentPayingNow: Date? = nil) {
        let stack = CoreDataStack.shared
        let context = stack.persistentContainer.viewContext

        
        let rent = Rent(context: context)
        rent.tenant = self
        rent.property = self.property
        rent.unit = self.unit
        rent.rent = self.unit!.rent
        
        if rent.tenant!.allPayments.isEmpty {
            // The tenant wont have any payments when is created in Management
            let oneMonth = DateComponents(calendar: .current, timeZone: .current, month: 1)
            let nextMonthRent = Calendar.current.date(byAdding: oneMonth, to: self.startingDate!)
            rent.dateRentIsDue = nextMonthRent
        } else {
            let oneMonth = DateComponents(calendar: .current, timeZone: .current, month: 1)
            let nextMonthRent = Calendar.current.date(byAdding: oneMonth, to: dateOfRentPayingNow!)
            rent.dateRentIsDue = nextMonthRent
        }
        
        stack.saveContext()
    }
}
