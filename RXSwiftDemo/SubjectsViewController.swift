//
//  SubjectsViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/14.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SubjectsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
//        publishSubject()
//        behaviorSubject()
//        replySubject()
        variable()
    }
    
    /**
     Variable 其实就是对 BehaviorSubject 的封装，所以它也必须要通过一个默认的初始值进行创建。
     Variable 具有 BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
     不同的是，Variable 还会把当前发出的值保存为自己的状态。同时它会在销毁时自动发送 .complete 的 event，不需要也不能手动给 Variables 发送 completed 或者 error 事件来结束它。
     简单地说就是 Variable 有一个 value 属性，我们改变这个 value 属性的值就相当于调用一般 Subjects 的 onNext() 方法，而这个最新的 onNext() 的值就被保存在 value 属性里了，直到我们再次修改它。
     注意：
     Variables 本身没有 subscribe() 方法，但是所有 Subjects 都有一个 asObservable() 方法。我们可以使用这个方法返回这个 Variable 的 Observable 类型，拿到这个 Observable 类型我们就能订阅它了。
     */
    func variable() {
        
        let varible = Variable("默认值")
        
        varible.value = "111"
        
        _ = varible.asObservable().subscribe {
            print("第一次订阅: ", $0)
        }
        
        varible.value = "222"
        
        _ = varible.asObservable().subscribe{
            print("第二次订阅: ",$0)
        }
        
        varible.value = "333"
    }
    
    /**
     ReplaySubject 在创建时候需要设置一个 bufferSize，表示它对于它发送过的 event 的缓存个数。
     比如一个 ReplaySubject 的 bufferSize 设置为 2，它发出了 3 个 .next 的 event，那么它会将后两个（最近的两个）event 给缓存起来。此时如果有一个 subscriber 订阅了这个 ReplaySubject，那么这个 subscriber 就会立即收到前面缓存的两个 .next 的 event。
     如果一个 subscriber 订阅已经结束的 ReplaySubject，除了会收到缓存的 .next 的 event 外，还会收到那个终结的 .error 或者 .complete 的 event。
     */
    func replySubject() {
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        //第一次订阅
        _ = subject.subscribe { (event) in
            print("第一次订阅: ",event)
        }
        
        //再发送一个next事件
        subject.onNext("444")

        //第二次订阅
        _ = subject.subscribe { (event) in
            print("第二次订阅: ", event)
        }

        //结束订阅
        subject.onCompleted()

        //第三次订阅,会先接收缓存的2个next事件,再接收complete事件
        _ = subject.subscribe { (event) in
            print("第三次订阅: ", event)
        }
        
    }
    
    /**
     BehaviorSubject 需要通过一个默认初始值来创建。
     当一个订阅者来订阅它的时候，这个订阅者会立即收到 BehaviorSubjects 上一个发出的 event。之后就跟正常的情况一样，它也会接收到 BehaviorSubject 之后发出的新的 event。
     */
    func behaviorSubject() {
        
        let subject = BehaviorSubject(value: "默认值")
        _ = subject.subscribe { (event) in
            print("第一次订阅", event)
        }
        
        //发送next事件给订阅者
        subject.onNext("111")
        
        //发送error事件给订阅者
//        subject.onError(NSError(domain: "local", code: 0, userInfo: nil))

        //发送error事件后,将不再接收事件
        subject.onNext("222")
        
        _ = subject.subscribe { (event) in
            print("第二次订阅", event)
        }
    
    }
    
    /**
     PublishSubject 是最普通的 Subject，它不需要初始值就能创建。
     PublishSubject 的订阅者从他们开始订阅的时间点起，可以收到订阅后 Subject 发出的新 Event，而不会收到他们在订阅前已发出的 Event。
     */
    func publishSubject() {
        
        //订阅者对象
        let subject = PublishSubject<String>()
        
        //给订阅者发送消息111,由于当前没有任何订阅者，所以这条信息不会输出到控制台
        subject.onNext("111")
        
        //第一次订阅
        _ = subject.subscribe(onNext: { (event) in
            print("第一次订阅\(event)")
        }, onCompleted: {
            print("第一次订阅完成")
        })
        
        //发送222给订阅者
        subject.onNext("222")
        
        //第二次订阅
        _ = subject.subscribe(onNext: { (event) in
            print("第二次订阅\(event)")
        }, onCompleted:{
            print("第二次订阅完成")
        })
        
        //发送333给订阅者
        subject.onNext("333")
        
        //发送onCompleted给订阅者
        subject.onCompleted()
        
        //订阅已经完成,订阅者将不再接收消息
        subject.onNext("444")
        
        //subject完成后它的所有订阅（包括结束后的订阅），都能收到subject的.completed事件，
        _ = subject.subscribe(onNext: { (event) in
            print("第三次订阅\(event)")
        }, onCompleted: {
            print("第三次订阅完成")
        })
        
    }

}
