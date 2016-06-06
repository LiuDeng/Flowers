//
//  GameToPlayerModel.swift
//  Flowers
//
//  Created by Jozsef Romhanyi on 02/06/2016.
//  Copyright © 2016 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import RealmSwift

class GameToPlayerModel: Object {
    dynamic var ID = 0
    dynamic var playerID = 0
    dynamic var gameID = 0
    dynamic var score = 0
    dynamic var created = NSDate()
    
    override  class func primaryKey() -> String {
        return "ID"
    }
    
    
}
