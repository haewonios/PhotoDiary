//
//  PostViewController.swift
//  PhotoDiary
//
//  Created by haewon on 2024/05/15.
//

import UIKit

class PostViewController: UIViewController {
    
    private lazy var imageView = UIImageView().then {
        $0.backgroundColor = .systemGray
    }
    
    private lazy var titleTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "제목을 입력해주세요"
        $0.returnKeyType = .done
        $0.clearButtonMode = .whileEditing
    }
    
    private lazy var contentTextView = UITextView().then {
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray6.cgColor
        
        $0.text = "내용을 입력해주세요"
        $0.textColor = .lightGray
    }
    
    private lazy var buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    private lazy var cancelButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        $0.layer.borderWidth = 1
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = configuration
        
        $0.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    private lazy var registerButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        $0.layer.borderWidth = 1
        $0.setTitle("등록", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        buildLayout()
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
        contentTextView.delegate = self
    }
    
    func buildLayout() {
        self.view.addSubview(imageView)
        self.view.addSubview(titleTextField)
        self.view.addSubview(contentTextView)
        self.view.addSubview(buttonStack)
        
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(registerButton)
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(view.frame.width - 60)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(200)
        }
        
        buttonStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    @objc
    func cancelTapped() {
        
        let alert = UIAlertController(title: "취소", message: "일기 작성을 취소하시겠어요?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        let confirm = UIAlertAction(title: "예", style: .default) { _ in
            self.dismiss(animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        self.present(alert, animated: true)
    }
}

extension PostViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해주세요"
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
}
