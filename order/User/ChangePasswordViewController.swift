//
//  ChangePasswordViewController.swift
//  order
//
//  Created by yigua on 2022/4/17.
//

import Foundation
import Eureka
import ProgressHUD

class ChangePasswordViewController: FormViewController {
    
    let disposeBag = DisposeBag()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "修改密码"
        form
        +++ PasswordRow("old"){
            $0.title = "当前密码"
            $0.placeholder = "当前密码"
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        <<< PasswordRow("new"){
            $0.title = "新密码"
            $0.placeholder = "新密码"
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        <<< PasswordRow("again"){
            $0.title = "确认新密码"
            $0.placeholder = "确认新密码"
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        +++ ButtonRow() {
            $0.title = "修改"
        }.onCellSelection({ [weak self] _, _ in
            self?.submit()
        })
    }
    
    private func submit() {
        guard form.validate().isEmpty else { return }
        let values = form.values()
        let old = values["old"] as? String ?? ""
        let new = values["new"] as? String ?? ""
        let again = values["again"] as? String ?? ""
        guard new == again else {
            ProgressHUD.showFailed("两次密码不一致")
            return
        }
        apiProvider.rx
            .request(.changePassword(old: old, new: new))
            .filterError()
            .subscribe(onSuccess: {[weak self] _ in
                ProgressHUD.showSuccess()
                self?.navigationController?.popViewController()
            }, onFailure: { _ in
                
            })
            .disposed(by: disposeBag)

    }
}
