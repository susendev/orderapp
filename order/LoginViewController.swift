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

class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .red
        return view
    }()

    lazy var usernameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.text = "账号:"
        view.textAlignment = .right
        return view
    }()
    
    lazy var usernameInput: UITextField = {
        let view = UITextField()
        view.placeholder = "请输入账号"
        view.borderStyle = .none
        return view
    }()
    
    lazy var usernameInputLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    lazy var passwordLabel: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.text = "密码:"
        view.textAlignment = .right
        return view
    }()
    
    lazy var passwordInput: UITextField = {
        let view = UITextField()
        view.placeholder = "请输入密码"
        view.borderStyle = .none
        return view
    }()
    
    lazy var passwordInputLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let view = UIButton(type: .custom)
        view.backgroundColor = .main
        view.setTitle("登录", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        bindData()
    }
    
    func setViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(icon)
        view.addSubview(usernameLabel)
        view.addSubview(usernameInput)
        view.addSubview(usernameInputLine)
        view.addSubview(passwordLabel)
        view.addSubview(passwordInput)
        view.addSubview(passwordInputLine)
        view.addSubview(loginButton)
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
            make.width.height.equalTo(100)
        }
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(80)
            make.top.equalTo(icon.snp.bottom).offset(50)
            make.width.equalTo(50)
        }
        usernameInput.snp.makeConstraints { make in
            make.leading.equalTo(usernameLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-80)
            make.height.equalTo(usernameLabel)
            make.bottom.equalTo(usernameLabel)
        }
        usernameInputLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(usernameInput)
            make.height.equalTo(1)
        }
        passwordLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(80)
            make.top.equalTo(usernameLabel.snp.bottom).offset(15)
            make.width.equalTo(50)
        }
        passwordInput.snp.makeConstraints { make in
            make.leading.equalTo(passwordLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-80)
            make.height.equalTo(passwordLabel)
            make.bottom.equalTo(passwordLabel)
        }
        passwordInputLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(passwordInput)
            make.height.equalTo(1)
        }
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.top.equalTo(passwordLabel.snp.bottom).offset(50)
        }
        
    }
    
    func bindData() {
        loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
    }
    
    @objc func loginButtonAction() {
        guard let username = usernameInput.text,
              let password = passwordInput.text else { return }
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
