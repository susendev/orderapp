//
//  UserModel.swift
//  order
//
//  Created by yigua on 2022/4/16.
//

import Foundation

enum Role: String, Codable  {
    case admin
    case user
    var functions: [String] {
        switch self {
        case .admin:
            return ["教室管理", "订单管理", "用户管理", "教室管理", "退出登录"]
        case .user:
            return ["预定教室", "我的预定", "修改密码", "退出登录"]
        }
    }
}

struct User: Codable {
    
    var id: String
    
    var username: String

    var role: Role
    
}
