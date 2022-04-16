//
//  ViewController.swift
//  order
//
//  Created by yigua on 2022/4/14.
//

import UIKit

class ViewController: UIViewController {

    lazy var welcomeLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .title3)
        view.textColor = .secondaryLabel
        view.text = "欢迎回来"
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        view.textColor = .label
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 40
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(cellWithClass: FunctionCell.self)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    var datas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(welcomeLabel)
        view.addSubview(nameLabel)
        view.addSubview(collectionView)
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(15)
        }
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.top.equalTo(nameLabel.snp.bottom).offset(50)
            make.bottom.equalToSuperview()
        }
        NotificationCenter.default.addObserver(forName: .userChnage, object: nil, queue: nil) { _ in
            self.bindData()
        }
        self.bindData()
    }
    
    func bindData() {
        datas = State.shared.user?.role.functions ?? []
        nameLabel.text = State.shared.user?.username
        collectionView.reloadData()
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FunctionCell.self, for: indexPath)
        cell.titleLabel.text = datas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(RoomsViewController(), animated: true)
    }
    
}

class FunctionCell: UICollectionViewCell {

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .title3)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .main
        layer.cornerRadius = 5
        layer.masksToBounds = true
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

