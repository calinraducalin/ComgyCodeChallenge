//
//  PredicateMaker.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import Foundation

struct PredicateMaker {
    static func makeTextPredicate(propertyName: String, value: String) -> NSPredicate {
        NSPredicate(format: "%K BEGINSWITH[c] %@", propertyName, value)
    }
    static func makeSyncedPredicate(synced: Bool) -> NSPredicate {
        NSPredicate(format: "%K == %@", "synced", NSNumber(value: synced))
    }
    static func makeIDPredicate(id: String) -> NSPredicate {
        NSPredicate(format: "%K == %@", "id", id)
    }
}
