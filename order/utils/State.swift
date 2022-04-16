//
//  State.swift
//  order
//
//  Created by yigua on 2022/4/16.
//

import Foundation
import RxSwift
import SwiftUI

class State {
    static let shared = State()
    
    var user: User? {
        didSet {
            NotificationCenter.default.post(name: .userChnage, object: nil)
        }
    }
    
}

