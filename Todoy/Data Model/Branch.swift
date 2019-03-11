//
//  Branch.swift
//  Todoy
//
//  Created by Balakrishna on 10/03/19.
//  Copyright © 2019 Balakrishna. All rights reserved.
//

import Foundation
import RealmSwift
class Branch: Object {
    
    @objc dynamic var name : String = ""
    let subjects = List<Subject>()
    
}
