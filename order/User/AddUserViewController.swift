//
//  AddUserViewController.swift
//  order
//
//  Created by yigua on 2022/4/17.
//

import Foundation
import Eureka
import ProgressHUD

class AddUserViewController: FormViewController {
    
    let disposeBag = DisposeBag()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "添加用户"
        form +++ TextRow("username"){
            $0.title = "用户名"
            $0.placeholder = "例如：zhangsan"
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        <<< PasswordRow("password"){
            $0.title = "密码"
            $0.placeholder = "用户密码"
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        <<<  ActionSheetRow<String>("role") {
            $0.title = "角色"
            $0.selectorTitle = "选择角色"
            $0.options = ["admin", "user"]
            $0.value = "user"
        }
        +++ ButtonRow() {
            $0.title = "添加"
        }.onCellSelection({ [weak self] _, _ in
            self?.submit()
        })
    }
    
    private func submit() {
        guard form.validate().isEmpty else { return }
        var dic = [String: Any]()
        form.values().forEach {
            if $0.value != nil {
                dic[$0.key] = $0.value!
            }
        }
        let api: API
        api = .addUser(detail: dic)
        apiProvider.rx
            .request(api)
            .filterError()
            .subscribe { [weak self] _ in
                ProgressHUD.showSuccess()
                self?.navigationController?.popViewController()
            }
            .disposed(by: disposeBag)

    }
}
