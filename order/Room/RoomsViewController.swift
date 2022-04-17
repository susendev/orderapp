//
//  RoomsViewController.swift
//  order
//
//  Created by yigua on 2022/4/16.
//

import Foundation
import UIKit
import RxSwift

class RoomsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(cellWithClass: RoomsTableViewCell.self)
        view.rowHeight = 56
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    var datas = [Room]() {
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
        navigationItem.title = role == .user ? "选择教室" : "教室管理"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if role == .admin {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        }
    }
    
    private func bindData() {
        apiProvider.rx
            .request(.allRooms)
            .filterError()
            .map([Room].self, atKeyPath: "data")
            .subscribe { [weak self] rooms in
                self?.datas = rooms
            } onFailure: { error in
                
            } onDisposed: {
                
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func addAction() {
        self.navigationController?.pushViewController(RoomDetailViewController(room: nil), animated: true)
    }
    
    private func delete(_ room: Room) {
        let alert = UIAlertController(title: "是否删除", message: nil, preferredStyle: .alert)
        alert.addAction(title: "取消", style: .cancel, isEnabled: true) { _ in
//            alert.dismiss(animated: true)
        }
        alert.addAction(title: "删除", style: .destructive, isEnabled: true) { _ in
//            alert.dismiss(animated: true)
            self.deleteRoom(room)
        }
        alert.show()
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

extension RoomsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RoomsTableViewCell.self, for: indexPath)
        let model = datas[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = model.address
        cell.valueLabel.text = "剩余：\(model.unScheduledSeats)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let room = datas[indexPath.row]
        if role == .admin {
            self.navigationController?.pushViewController(RoomDetailViewController(room: room), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let room = datas[indexPath.row]
        self.delete(room)
    }
}


class RoomsTableViewCell: UITableViewCell {
    
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
