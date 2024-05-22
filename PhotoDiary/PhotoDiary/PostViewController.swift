//
//  PostViewController.swift
//  PhotoDiary
//
//  Created by haewon on 2024/05/15.
//

import UIKit
import AVFoundation
import PhotosUI

class PostViewController: UIViewController {
    
    private lazy var imageView = UIImageView().then {
        $0.backgroundColor = .systemGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickPhoto))
        $0.addGestureRecognizer(tapGesture)
        $0.isUserInteractionEnabled = true
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
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
        titleTextField.delegate = self
        contentTextView.delegate = self
        setKeyboardObserver()
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
            $0.height.equalTo(view.frame.height*0.25)
        }
        
        buttonStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc
    func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
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

extension PostViewController: UITextViewDelegate, UITextFieldDelegate {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
    @objc
    func pickPhoto() {
        print("uiimageview tapped")
        
        let alert = UIAlertController(title: nil, message: "사진을 등록해주세요.", preferredStyle: .actionSheet)
        let album = UIAlertAction(title: "앨범에서 가져오기", style: .default) { _ in
            self.checkAlbumAuth()
        }
        let camera = UIAlertAction(title: "카메라로 촬영하기", style: .default) { _ in
            self.checkCameraAuth()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(album)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    func checkAlbumAuth() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized:
            print("authorized")
            openAlbum()
        case .denied:
            print("denied")
            openSettings("앨범")
        case .notDetermined:
            print("not determined")
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { state in
                if state == .authorized {
                    print("AUTHORIZED")
                } else {
                    print("state: \(state)")
                }
            }
        case .limited:
            print("limited")
            openAlbum()
        case .restricted:
            print("restricted")
        @unknown default:
            fatalError()
        }
    }
    
    func checkCameraAuth() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            print("authorized")
            openCamera()
        case .denied:
            print("denied")
            openSettings("카메라")
        case .notDetermined:
            print("not determined")
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    print("access ok")
                    self.openCamera()
                } else {
                    print("access denied")
                    self.openSettings("카메라")
                }
            }
        default:
            print("default")
        }
    }
    
    func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func openAlbum() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.isEditing = true
        present(picker, animated: true)
    }
    
    func openSettings(_ name: String) {
        let alert = UIAlertController(title: "설정", message: "\(name) 접근 허용이 필요합니다. 설정으로 이동하시겠어요?", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "예", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        }
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else {
            picker.dismiss(animated: true)
            return
        }
        
        let _ = itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
            DispatchQueue.main.async {
                guard let image = image as? UIImage else { return }
                self.imageView.image = image
            }
        }
        picker.dismiss(animated: true)
    }
}
