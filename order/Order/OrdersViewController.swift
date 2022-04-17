//
//  OrdersViewController.swift
//  order
//
//  Created by yigua on 2022/4/17.
//

import Foundation
import UIKit
import RxSwift

class OrdersViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(cellWithClass: RoomsTableViewCell.self)
        view.rowHeight = 56
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    var datas = [Order]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var role: Role {
        return State.shared.user?.role ?? .user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        bindData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindData()
    }
    
    private func setViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = role == .user ? "我的订单" : "订单列表"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindData() {
        let user = State.shared.user?.role == .user ? State.shared.user?.id : nil
        apiProvider.rx
            .request(.orders(user: user))
            .filterError()
            .map([Order].self, atKeyPath: "data")
            .subscribe { [weak self] rooms in
                self?.datas = rooms
            } onFailure: { error in
                
            } onDisposed: {
                
            }
            .disposed(by: disposeBag)
    }
        
    private func deleteRoom(_ room: Room) {
        apiProvider.rx
            .request(.deleteRoom(id: room.id))
            .filterError()
            .subscribe { [weak self] _ in
                self?.bindData()
            } onFailure: { error in
                
            } onDisposed: {
                
            }
            .disposed(by: disposeBag)
    }
    
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RoomsTableViewCell.self, for: indexPath)
        let model = datas[indexPath.row]
        cell.textLabel?.text = model.roomName
        if State.shared.user?.role == .admin {
            cell.detailTextLabel?.text = model.userName
        }
        cell.valueLabel.text = "预定日期：\(model.date)"
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let room = datas[indexPath.row]
//        if role == .admin {
//            self.navigationController?.pushViewController(RoomDetailViewController(room: room), animated: true)
//        } else {
//            self.navigationController?.pushViewController(OrderViewController(room: room), animated: true)
//        }
    }

}


class OrdersTableViewCell: UITableViewCell {
    
    lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.textColor = .secondaryLabel
        view.font = UIFont.preferredFont(forTextStyle: .caption1)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setViews()
    }
    
    private func setViews() {
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
