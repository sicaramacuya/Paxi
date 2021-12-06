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
    let unit: [ManageTestingUnit]
}

struct ManageTestingUnit {
    let title: String
    let amount: Double
    let tenant: [ManageTestingTenant]
}

struct ManageTestingTenant {
    let title: String
    let amount: Double
}
