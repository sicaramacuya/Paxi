//
//  ManageTestingEntities.swift
//  Paxi
//
//  Created by Eric Morales on 12/6/21.
//

import Foundation

struct ManageTestingProperty {
    let title: String
    let amount: Double
    let units: [ManageTestingUnit]
}

struct ManageTestingUnit {
    let title: String
    let amount: Double
    let tenants: [ManageTestingTenant]
}

struct ManageTestingTenant {
    let title: String
    let amount: Double
    let payments: [ManageTestingPayments]
}

struct ManageTestingPayments {
    let date: Date
    let amount: Double
}
