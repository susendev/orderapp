//
//  RoomDetailViewController.swift
//  order
//
//  Created by yigua on 2022/4/16.
//

import Foundation
import Eureka
import ProgressHUD

class RoomDetailViewController: FormViewController {
    
    let disposeBag = DisposeBag()
    var room: Room?
    
    init(room: Room?) {
        super.init(nibName: nil, bundle: nil)
        self.room = room
        self.navigationItem.title = room == nil ? "添加教室" : room?.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        form +++ TextRow("name"){
            $0.title = "教室名"
            $0.placeholder = "例如：303"
            $0.value = room?.name
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        <<< TextRow("address"){
            $0.title = "教室地址"
            $0.placeholder = "例如：1号教学楼"
            $0.value = room?.address
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        <<< IntRow("seats"){
            $0.title = "座位数量"
            $0.placeholder = "0"
            $0.value = room?.seats
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        +++ ButtonRow() {
            $0.title = room == nil ? "添加" : "修改"
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
        if let room = room {
            api = .changeRoomDetail(id: room.id, detail: dic)
        } else {
            dic["scheduledSeats"] = 0
            api = .addRoom(detail: dic)
        }
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
