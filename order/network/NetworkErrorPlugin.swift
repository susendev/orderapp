//
//  NetworkErrorPlugin.swift
//  order
//
//  Created by yigua on 2022/4/16.
//

import Foundation
import Moya
import ProgressHUD

public extension ObservableType where Element == Response {

    func filterError() -> Observable<Response> {
        flatMap { Observable.just(try $0.filterError()) }
    }
    
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    
    func filterError() -> Single<Element> {
        flatMap { .just(try $0.filterError()) }
    }

}

public extension Response {

    func filterError() throws -> Response {
        guard let json = try self.mapJSON() as? [String: Any] else {
            return self
        }
        if let code = json["code"] as? Int,
            code != 20000 {
            let message = json["message"] as? String ?? "未知错误"
            ProgressHUD.showFailed(message, interaction: true)
            throw NSError(domain: message, code: code)
        }
        return self
    }

}
