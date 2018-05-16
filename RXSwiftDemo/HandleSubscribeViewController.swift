//
//  HandleSubscribeViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/14.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HandleSubscribeViewController: UIViewController {

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        //MARK:--订阅处理
        //        switchSubscribe()
        //        doon()
        //        disposeSubscription()
                disposeBag()
    }

    
    /**
     DisposeBag
     （1）除了 dispose() 方法之外，我们更经常用到的是一个叫 DisposeBag 的对象来管理多个订阅行为的销毁：
     我们可以把一个 DisposeBag 对象看成一个垃圾袋，把用过的订阅行为都放进去。
     而这个 DisposeBag 就会在自己快要 dealloc 的时候，对它里面的所有订阅行为都调用 dispose() 方法。
     */
    func disposeBag() {
        
        let observable1 = Observable.of("A", "B", "C")
        
        _ = observable1.subscribe { (event) in
            print(event)
            }.disposed(by: bag)
        
        
        let observable2 = Observable.of(1, 2, 3)
        
        _ = observable2.subscribe { (event) in
            print(event)
            }.disposed(by: bag)
    }
    
    /**
     dispose() 方法
     （1）使用该方法我们可以手动取消一个订阅行为。
     （2）如果我们觉得这个订阅结束了不再需要了，就可以调用 dispose() 方法把这个订阅给销毁掉，防止内存泄漏。
     （2）当一个订阅行为被 dispose 了，那么之后 observable 如果再发出 event，这个已经 dispose 的订阅就收不到消息了。下面是一个简单的使用样例。
     */
    func disposeSubscription() {
        let observable = Observable.of("A", "B", "C")
        
        //使用subscription常量存储这个订阅方法
        let subscription = observable.subscribe { event in
            print(event)
        }
        
        //调用这个订阅的dispose()方法
        subscription.dispose()
    }
    
    /**
     doOn 介绍
     （1）我们可以使用 doOn 方法来监听事件的生命周期，它会在每一次事件发送前被调用。
     （2）同时它和 subscribe 一样，可以通过不同的 block 回调处理不同类型的 event。比如：
     do(onNext:) 方法就是在 subscribe(onNext:) 前调用
     而 do(onCompleted:) 方法则会在 subscribe(onCompleted:) 前面调用。
     */
    func doon() {
        
        _ = Observable.of("A", "B", "C").do(onNext: { (element) in
            print("next信号发送前调用:\(element)")
        }, onError: { (error) in
            print("error信号发送前调用:\(error)")
        }, onCompleted: {
            print("complete信号发送前调用")
        }, onSubscribe: {
            print("aaa")
        }, onSubscribed: {
            print("bbb")
        }, onDispose: {
            print("订阅者disposed后,doon函数体才会disposed")
            
        }).subscribe(onNext: { (element) in
            print(element)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("complete")
        }, onDisposed: {
            print("disposed")
        })
    }
    
    /**
     RxSwift 还提供了另一个 subscribe 方法，它可以把 event 进行分类：
     通过不同的 block 回调处理不同类型的 event。（其中 onDisposed 表示订阅行为被 dispose 后的回调，这个我后面会说）
     同时会把 event 携带的数据直接解包出来作为参数，方便我们使用。
     */
    func switchSubscribe() {
        _ = Observable.of("A", "B", "C").subscribe(onNext: { element in
            print(element)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("complete")
        }, onDisposed: {
            print("disposed")
        })
    }

}
