//
//  ViewController.swift
//  RxSwift-demo
//
//  Created by 李永杰 on 2018/8/8.
//  Copyright © 2018年 muheda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

fileprivate let verticalSpace = 5
fileprivate let minimalUsernameLength = 5
fileprivate let minimalPasswordLength = 5

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        handleRx()
    }
    private func handleRx() {
        let usernameValid = userNameField.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share( replay: 1 )
        let passwordValid = passwordField.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share ( replay: 1 )
        let bothValid = Observable.combineLatest(usernameValid,passwordValid){ $0&&$1 }.share(replay: 1)
        
        usernameValid
            .bind(to: passwordField.rx.isEnabled)
            .disposed(by: disposeBag)
        usernameValid.bind(to: userNameTip.rx.isHidden).disposed(by: disposeBag)
        passwordValid.bind(to: passwordTip.rx.isHidden).disposed(by: disposeBag)
        bothValid.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.showAlert()
            }
        ).disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alertView = UIAlertView(title: "ExExample", message: "This is wonderful", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    private func configUI() {
        view.addSubview(userNameLabel)
        view.addSubview(userNameField)
        view.addSubview(userNameTip)
        view.addSubview(passwordLabel)
        view.addSubview(passwordField)
        view.addSubview(passwordTip)
        view.addSubview(loginButton)
        
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(100)
            make.top.equalTo(100)
            make.height.equalTo(20)
        }
        userNameField.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.height.equalTo(40)
            make.top.equalTo(userNameLabel.snp.bottom).offset(verticalSpace)
        }
        userNameTip.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(userNameField)
            make.top.equalTo(userNameField.snp.bottom).offset(verticalSpace)
        }
        
        passwordLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(userNameLabel)
            make.top.equalTo(userNameTip.snp.bottom).offset(verticalSpace)
        }
        passwordField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(userNameField)
            make.top.equalTo(passwordLabel.snp.bottom).offset(verticalSpace)
        }
        passwordTip.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(userNameTip)
            make.top.equalTo(passwordField.snp.bottom).offset(verticalSpace)
        }
        loginButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(passwordTip)
            make.height.equalTo(59)
            make.top.equalTo(passwordTip.snp.bottom).offset(verticalSpace)
        }
    }
 
    
    private lazy var userNameLabel:UILabel = {
        let lab = UILabel.init()
        lab.text = "Username"
        return lab
    }()
    private lazy var userNameField:UITextField = {
        let field = UITextField.init()
        field.placeholder = "input username"
        return field
    }()
    private lazy var userNameTip:UILabel = {
        let lab = UILabel.init()
        lab.text = "Username has to be at least 5 characters"
        lab.textColor = .red
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    
    private lazy var passwordLabel:UILabel = {
        let lab = UILabel.init()
        lab.text = "Password"
        return lab
    }()
    private lazy var passwordField:UITextField = {
        let field = UITextField.init()
        field.placeholder = "input password"
        return field
    }()
    private lazy var passwordTip:UILabel = {
        let lab = UILabel.init()
        lab.text = "Password has to be at least 5 charaters"
        lab.textColor = .red
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    
    private lazy var loginButton:UIButton = {
        let btn = UIButton.init()
        btn.setTitle("login", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.red, for: .disabled)
        return btn
    }()
    
}

