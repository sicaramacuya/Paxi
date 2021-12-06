//
//  Selection.swift
//  Paxi
//
//  Created by Eric Morales on 12/4/21.
//

import Foundation
import UIKit

enum Selection: String {
    case agenda = "list.bullet.rectangle.portrait.fill"
    case dashboard = "rectangle.3.group.fill"
    case managment = "rectangle.grid.1x2.fill"
    case history = "calendar"
    case payment = "square.text.square.fill"
    case tenants = "person.3.fill"
    case units = "house.fill"
    
    
    func getString() -> String {
        switch self {
        case .agenda:
            return "Agenda"
        case .dashboard:
            return "Dashboard"
        case .managment:
            return "Managment"
        case .history:
            return "History"
        case .payment:
            return "Payment"
        case .tenants:
            return "Tenants"
        case .units:
            return "Units"
        }
    }
    
    func getTint() -> UIColor {
        switch self {
        case .agenda:
            return .systemPurple
        case .dashboard:
            return .systemOrange
        case .managment:
            return .systemYellow
        case .history:
            return .systemBlue
        case .payment:
            return .systemGreen
        case .tenants:
            return .systemPink
        case .units:
            return .systemMint
        }
    }
}

