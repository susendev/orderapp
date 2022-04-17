//
//  LoginViewController.swift
//  order
//
//  Created by yigua on 2022/4/15.
//

import UIKit
import RxSwift
import Defaults
import ProgressHUD
import Eureka

class LoginViewController: FormViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    func setViews() {
        view.backgroundColor = .systemBackground
        
        form
        +++ Section(header: "欢迎使用座位预定系统", footer: "忘记密码或需要注册请联系管理员")
        <<< TextRow("username"){
            $0.title = "账号"
            $0.placeholder = "你的账号"
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        <<< PasswordRow("password"){
            $0.title = "密码"
            $0.placeholder = "你的密码"
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
            
        +++ ButtonRow() {
            $0.title = "登录"
        }.onCellSelection({ [weak self] _, _ in
            self?.submit()
        })
    }

    func submit() {
        guard form.validate().isEmpty else { return }
        let values = form.values()
        guard let username = values["username"] as? String,
              let password = values["password"] as? String else { return }
        apiProvider.rx
            .request(.userLogin(username: username, password: password))
            .filterError()
            .map(User.self, atKeyPath: "data")
            .subscribe { [weak self] user in
                Defaults[.user] = user
                State.shared.user = user
                ProgressHUD.showSucceed("登录成功", interaction: true)
                self?.dismiss(animated: true, completion: nil)
            } onFailure: { error in
                
            } onDisposed: {
                
            }
            .disposed(by: disposeBag)
            
    }

}
