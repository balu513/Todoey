//
//  Subject.swift
//  Todoy
//
//  Created by Balakrishna on 10/03/19.
//  Copyright © 2019 Balakrishna. All rights reserved.
//

import Foundation
import RealmSwift
class Subject : Object{
    
    @objc dynamic var name : String = ""
    
    @objc dynamic var isDone : Bool = false
    
    @objc dynamic var createdDate : Date?
    
    var parentBranch = LinkingObjects(fromType: Branch.self, property: "subjects")
    
    
}
