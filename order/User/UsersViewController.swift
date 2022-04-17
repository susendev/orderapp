//
//  UsersViewController.swift
//  order
//
//  Created by yigua on 2022/4/17.
//

import Foundation
import UIKit
import RxSwift
import ProgressHUD

class UsersViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(cellWithClass: RoomsTableViewCell.self)
        view.rowHeight = 56
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    var datas = [User]() {
        didSet {
            self.tableView.reloadData()
        }
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
        navigationItem.title = "用户管理"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
    }
    
    private func bindData() {
        apiProvider.rx
            .request(.allUsers)
            .filterError()
            .map([User].self, atKeyPath: "data")
            .subscribe { [weak self] rooms in
                self?.datas = rooms
            } onFailure: { error in
                
            } onDisposed: {
                
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func addAction() {
        self.navigationController?.pushViewController(AddUserViewController(), animated: true)
    }
    
    private func delete(_ user: User) {
        if user.role == .admin {
            ProgressHUD.showFailed("无法删除管理员")
            return
        }
        apiProvider.rx
            .request(.deleteUser(id: user.id))
            .filterError()
            .subscribe { [weak self] _ in
                self?.bindData()
            } onFailure: { error in
                
            } onDisposed: {
                
            }
            .disposed(by: disposeBag)
    }
        
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RoomsTableViewCell.self, for: indexPath)
        let model = datas[indexPath.row]
        cell.textLabel?.text = model.username
        cell.valueLabel.text = model.role == .admin ? "管理员" : "用户"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = datas[indexPath.row]
        let alert = UIAlertController(title: "选择操作", message: nil, preferredStyle: .actionSheet)
        alert.addAction(title: "取消", style: .cancel, isEnabled: true) { _ in

        }
        alert.addAction(title: "删除", style: .destructive, isEnabled: true) { _ in
            self.delete(user)
        }
//        alert.addAction(title: "充值密码", style: .destructive, isEnabled: true) { _ in
//            self.deleteRoom(room)
//        }
        alert.show()
    }

}


class UsersTableViewCell: UITableViewCell {
    
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
