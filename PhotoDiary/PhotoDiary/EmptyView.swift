//
//  EmptyView.swift
//  PhotoDiary
//
//  Created by haewon on 2024/05/15.
//

import UIKit

class EmptyView: UIView {
    
    private lazy var emptyMessage = UILabel().then {
        $0.text = "목록이 비었어요.🥲\n\n일기를 작성해주세요!"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var createFirstButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        
        $0.setTitle("첫 일기 작성하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        $0.configuration = configuration
        
        $0.addTarget(self, action: #selector(createPost), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildLayout() {
        self.addSubview(emptyMessage)
        self.addSubview(createFirstButton)
        
        emptyMessage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.centerX.equalToSuperview()
        }
        
        createFirstButton.snp.makeConstraints {
            $0.top.equalTo(emptyMessage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc
    func createPost() {
        let postViewController = PostViewController()
        postViewController.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(postViewController, animated: true)
    }
}
