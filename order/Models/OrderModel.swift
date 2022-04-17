//
//  OrderModel.swift
//  order
//
//  Created by yigua on 2022/4/17.
//

import Foundation

struct Order: Codable {
    
    var id: String

    var userId: String
    
    var userName: String

    var roomId: String
    
    var roomName: String

    var date: String
    
}
