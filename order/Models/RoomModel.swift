//
//  RoomModel.swift
//  order
//
//  Created by yigua on 2022/4/16.
//

import Foundation

struct Room: Codable {
    
    var id: UUID?

    var name: String
    
    var address: String
    
    var seats: Int
    
    var scheduledSeats: Int
    
    var unScheduledSeats: Int
    
}
