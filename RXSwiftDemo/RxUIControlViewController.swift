//
//  TestViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/15.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxUIControlViewController: UIViewController {
    
    let bag = DisposeBag()
    
    lazy var label: UILabel = {
        let lab = UILabel(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 30))
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var textField:UITextField = {
       let textField = UITextField(frame: CGRect(x: 0, y: 150, width: UIScreen.main.bounds.size.width, height: 30))
        textField.placeholder = "请输入"
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(label)
        
        view.addSubview(textField)

//        bindLabelText()
        
//        bindLabelAttributedText()
        
//        bindTextFieldText()
        
        controlEvent()
    }
    
    /**
     事件监听
     */
    func controlEvent() {
        _ = textField.rx.controlEvent(UIControlEvents.editingDidBegin).asObservable().subscribe({ (event) in
            print("事件监听: editingDidBegin")
        })
    }
    
    /**
     当文本框内容改变时，将内容输出到控制台上
     */
    func bindTextFieldText() {
        //.orEmpty 可以将 String? 类型的 ControlProperty 转成 String，省得我们再去解包。
        _ = textField.rx.text.orEmpty.asObservable().subscribe{
            print("你输入的是: \($0)")
        }
    }
    
    /**
     当程序启动时就开始计时，同时将已过去的时间格式化后显示在 label 富文本标签上
     */
    func bindLabelAttributedText() {
        
        _ = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance).map(formatTimeInterval).bind(to: label.rx.attributedText)
        
    }
    
    func formatTimeInterval(time : NSInteger) -> NSMutableAttributedString {
        
        let str = String(format: "%0.2d:%0.2d:%0.1d", arguments: [(time % 600) % 600, (time % 600) / 10, time % 10])
        
        let attributeString = NSMutableAttributedString(string: str)
        
        attributeString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Bold", size: 16)!, range: NSMakeRange(0, 5))
        
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSMakeRange(0, 5))
        
        attributeString.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.blue, range: NSMakeRange(0, 5))
        
        return attributeString
    }

    /**
     当程序启动时就开始计时，同时将已过去的时间格式化后显示在 label 标签上
     */
    func bindLabelText() {
        
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        _ = timer.map {
            String(format: "%0.2d:%0.2d:%0.1d", arguments: [($0 / 600) % 600, ($0 % 600) / 10, $0 % 10])
            }.bind(to: label.rx.text)
        
    }

}
