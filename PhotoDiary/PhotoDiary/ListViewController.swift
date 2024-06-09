//
//  ListViewController.swift
//  PhotoDiary
//
//  Created by haewon on 2024/05/13.
//

import UIKit
import SnapKit
import Then

class ListViewController: UIViewController {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "나의 사진 일기"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    private lazy var tableView = UITableView()
    private lazy var emptyView = EmptyView()
    
    var postData: [PostInfo] = []
//    var postData: [PostInfo] = [PostInfo(image: "", title: "test", contents: "contents"),
//                                PostInfo(image: "", title: "test", contents: "contents"),
//                                PostInfo(image: "", title: "test", contents: "contents")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        buildLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPostData()
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
        
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func buildLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        if postData.count > 0 {
            setTableView()
        } else {
            setEmptyView()
        }
    }
    
    func setTableView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func setEmptyView() {
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func loadPostData() {
        print("🍊 load data start...")
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let path = documentURL.appendingPathComponent("postData.json")
        print("🍊 load data path - \(path)")
        let decoder = JSONDecoder()
        
        do {
            let jsonString = try String(contentsOf: path)
            guard let data = jsonString.data(using: .utf8), let jsonData = try? decoder.decode(PostInfo.self, from: data) else {
                return
            }
            print("🍊 load json data - \(jsonData)")
        } catch {
            print("🐸 ERROR: load data - \(error)")
        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        let post = postData[indexPath.row]
        cell.configureCell(post)
        
        return cell
    }
}
