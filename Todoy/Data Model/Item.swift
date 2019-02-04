//
//  Item.swift
//  Todoy
//
//  Created by Balakrishna on 04/02/19.
//  Copyright © 2019 Balakrishna. All rights reserved.
//

import Foundation

class Item : Encodable,Decodable{
    var itemVal : String = ""
    var stat : Bool = false
    
    init(item : String , status : Bool) {
        itemVal = item
        stat = status
    }
    
    init(item : String) {
        itemVal = item
        stat = false
    }
}
