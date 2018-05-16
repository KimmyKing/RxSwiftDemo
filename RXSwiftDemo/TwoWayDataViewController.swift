//
//  TwoWayDataViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/16.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct UserViewModel {
    
    let username = Variable("guest")
    
    lazy var userinfo = {
        return self.username.asObservable().map {
            $0 == "Cain" ? "管理员" : "游客"
        }.share(replay: 1)
    }()
}

class TwoWayDataViewController: UIViewController {

    var userVM = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.addSubview(textField)
        
        view.addSubview(label)
        
        //将用户名与textField做双向绑定
        _ = userVM.username.asObservable().bind(to: textField.rx.text)
        _ = textField.rx.text.orEmpty.bind(to: userVM.username)
        
        //将用户信息绑定到label上
        _ = userVM.userinfo.bind(to: label.rx.text)
        
    }
    
    lazy var label:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 150, width: UIScreen.main.bounds.size.width, height: 30))
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { (tap) in
            print("点击了label")
        })
        label.addGestureRecognizer(tap)
        return label
    }()

    lazy var textField:UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 30))
        return textField
    }()

}
