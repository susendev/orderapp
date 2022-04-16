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
        if json["code"] as? Int != 20000 {
            let message = json["message"] as? String
            ProgressHUD.showFailed(message ?? "未知错误", interaction: true)
        }
        return self
    }

}
