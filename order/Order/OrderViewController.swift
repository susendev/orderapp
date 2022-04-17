//
//  OrderViewController.swift
//  order
//
//  Created by yigua on 2022/4/17.
//

import Foundation
import Eureka
import RxSwift
import ProgressHUD

class OrderViewController: FormViewController {
    
    let disposeBag = DisposeBag()
    
    let room: Room
    
    init(room: Room) {
        self.room = room
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "预定教室"
        form
        +++ TextRow(){
            $0.title = "教室"
            $0.value = room.name
            $0.disabled = true
        }
        <<< TextRow(){
            $0.title = "地址"
            $0.value = room.address
            $0.disabled = true
        }
        <<< DateRow("date"){
            $0.title = "选择日期"
            $0.add(rule: RuleRequired())
        }.cellUpdate({ cell, row in
            
        })
        +++ ButtonRow() {
            $0.title = "添加"
        }.onCellSelection({ [weak self] _, _ in
            self?.submit()
        })
        
    }
    
    private func submit() {
        let row: DateRow? = form.rowBy(tag: "date")
        guard let date = row?.value else {
            ProgressHUD.showFailed("请选择日期")
            return
        }
        let api: API
        api = .order(user: State.shared.user?.id ?? "", room: room.id, date: date.dateString(ofStyle: .short))
        apiProvider.rx
            .request(api)
            .filterError()
            .subscribe(onSuccess: { [weak self] _ in
                ProgressHUD.showSuccess()
                self?.navigationController?.popViewController()
            }, onFailure: { _ in
                
            })
            .disposed(by: disposeBag)
        
    }
}
