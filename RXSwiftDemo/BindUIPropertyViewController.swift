//
//  BindUIPropertyViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/14.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BindUIPropertyViewController: UIViewController {

    let bag = DisposeBag()
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 30))
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    lazy var button:UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 30))
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.setTitle("普通状态", for: UIControlState.normal)
        button.setTitle("禁用状态", for: UIControlState.disabled)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        view.addSubview(label)
        view.addSubview(button)
        
        
        //MARK:--观察者
        //        bind()
        //        anyObservable()
        //        binder()
        //        observeStatus()
        //        observeFontByExtensionUILabel()
        observeFontByExtensionReactive()
    }
    
    /**
     既然使用了 RxSwift，那么更规范的写法应该是对 Reactive 进行扩展。这里同样是给 UILabel 增加了一个 fontSize 可绑定属性。
     */
    func observeFontByExtensionReactive() {
        label.text = "改变label字体大小"
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{CGFloat($0)}.bind(to: label.rx.fontsize).disposed(by: bag)
    }
    
    /**
     有时我们想让 UI 控件创建出来后默认就有一些观察者，而不必每次都为它们单独去创建观察者。比如我们想要让所有的 UIlabel 都有个 fontSize 可绑定属性，它会根据事件值自动改变标签的字体大小。
     */
    func observeFontByExtensionUILabel() {
        label.text = "改变字体大小"
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{CGFloat($0)}.bind(to: label.fontSize)
    }
    
    /**
     可以将序列直接绑定到它上面。比如下面样例，button 会在可用、不可用这两种状态间交替变换（每隔一秒）。
     */
    func observeStatus() {
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{ $0 % 2 == 0}.bind(to: button.rx.isEnabled)
    }
    
    /**
     label 标签的文字显示就是一个典型的 UI 观察者。它在响应事件时，只会处理 next 事件，而且更新 UI 的操作需要在主线程上执行。那么这种情况下更好的方案就是使用 Binder。
     */
    func binder() {
        let binder: Binder<String> = Binder.init(label) { (lab, text) in
            lab.text = text
        }
        
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{"当前索引数\($0)"}.bind(to: binder)
    }
    
    /**
     也可配合 Observable 的数据绑定方法（bindTo）使用
     */
    func anyObservable() {
        
        let observer:AnyObserver<String> = AnyObserver { [weak self] event in
            switch event {
            case .next(let text):
                self?.label.text = text
                
            default:
                break
            }
        }
        
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{"当前索引数: \($0)"}.bind(to: observer)
    }
    
    /**
     创建一个定时生成索引数的 Observable 序列，并将索引数不断显示在 label 标签上：
     */
    func bind() {
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).map { "当前索引数\($0)"}.bind { [weak self](text) in
            self?.label.text = text
        }
    }
}

extension UILabel {
    var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

extension Reactive where Base: UILabel {
    var fontsize: Binder<CGFloat> {
        return Binder.init(self.base, binding: { (label, fontsize) in
            label.font = UIFont.systemFont(ofSize: fontsize)
        })
    }
}
