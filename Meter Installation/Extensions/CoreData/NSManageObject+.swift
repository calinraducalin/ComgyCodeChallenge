//
//  NSManageObject+.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import CoreData

extension NSManagedObject {
    class var entityName: String {
        String(describing: self)
    }
}
