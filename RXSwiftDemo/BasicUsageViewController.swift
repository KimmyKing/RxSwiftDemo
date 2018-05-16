//
//  BasicUsageViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/14.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BasicUsageViewController: UIViewController {

    lazy var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        //MARK:--基础用法
        //        just()
        //        of()
        //        from()
        //        empty()
        //        never()
        //        error()
        //        range()
        //        repeatElement()
        //        generate()
        //        create()
        //        deferred()
        //        interval()
        timer()
    }

    /**
     13，timer() 方法: 相当于延时执行
     （1）这个方法有两种用法，一种是创建的 Observable 序列在经过设定的一段时间后，产生唯一的一个元素。
     （2）另一种是创建的 Observable 序列在经过设定的一段时间后，每隔一段时间产生一个元素。
     */
    func timer() {
        //5秒种后发出唯一的一个元素0
        _ = Observable<Int>.timer(5, scheduler: MainScheduler.instance).subscribe { (event) in
            print(event)
        }.disposed(by: bag)
        
        //延时5秒种后，每隔1秒钟发出一个元素
        _ = Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance).subscribe({ (event) in
            print(event)
        }).disposed(by: bag)
    }
    
    /**
     12，interval() 方法
     （1）这个方法创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去。
     （2）下面方法让其每 1 秒发送一次，并且是在主线程（MainScheduler）发送。
     */
    func interval() {
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).subscribe { (event) in
            print(event)
        }
    }
    
    /**
     11，deferred() 方法
     （1）该个方法相当于是创建一个 Observable 工厂，通过传入一个 block 来执行延迟 Observable 序列创建的行为，而这个 block 里就是真正的实例化序列对象的地方。
     */
    func deferred() {
        
        //标记奇数
        var isOdd = true
        //使用deferred()方法延迟Observable序列的初始化，通过传入的block来实现Observable序列的初始化并且返回。
        let factory: Observable<Int> = Observable.deferred {
            
            isOdd = !isOdd
            if isOdd {
                return Observable.of(1, 3, 5, 7)
            }else {
                return Observable.of(2, 4, 6, 8)
            }
            
        }
        
        //第1次订阅测试
        _ = factory.subscribe { (event) in
            print("\(isOdd)", event)
        }
        
        //第2次订阅测试
        _ = factory.subscribe { (event) in
            print("\(isOdd)", event)
        }
        
    }
    
    /**
     10，create() 方法
     （1）该方法接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理
     */
    func create() {
        //这个block有一个回调参数observer就是订阅这个Observable对象的订阅者
        //当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
        _ = Observable<String>.create { (observer) -> Disposable in
            //对订阅者发出了.next事件
            observer.onNext("Cain")
            //对订阅者发出了.completed事件
            observer.onCompleted()
            //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
            return Disposables.create()
            
            }.subscribe {
                print($0)
        }
        
    }
    
    /**
     9，generate() 方法
     （1）该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
     （2）下面样例中，两种方法创建的 Observable 序列都是一样的。
     */
    func generate() {
        _ = Observable.generate(
            //初始值
            initialState: 0,
            //条件:当参数小于10时,会一直接收信号,参数大于10时,才会发送complete信号,停止订阅信号
            condition: {$0 <= 10},
            //重复行为:condition为false时执行的函数体
            iterate: {$0 + 2}).subscribe {
                print($0)
        }
        
        _ = Observable.of(2, 4, 6, 8, 10).subscribe {
            print($0)
        }
        
    }
    
    /**
     8，repeatElement() 方法
     该方法创建一个可以无限发出给定元素的 Event 的 Observable 序列（永不终止）。
     */
    func repeatElement() {
        _ = Observable.repeatElement(1).subscribe {
            print($0)
        }
    }
    
    /**
     7，range() 方法
     （1）该方法通过指定起始和结束数值，创建一个以这个范围内所有值作为初始值的 Observable 序列。
     （2）下面样例中，两种方法创建的 Observable 序列都是一样的。
     */
    func range() {
        _ = Observable.range(start: 1, count: 5).subscribe {
            print($0)
        }
        
        _ = Observable.of(1, 2, 3, 4, 5).subscribe {
            print($0)
        }
    }
    
    /**
     6，error() 方法
     该方法创建一个不做任何操作，而是直接发送一个错误的 Observable 序列。
     */
    enum MyError:Error {
        case A
        case B
    }
    
    func error() {
        _ = Observable<Int>.error(MyError.A).subscribe {
            print($0)
        }
    }
    
    /**
     5，never() 方法
     该方法创建一个永远不会发出 Event（也不会终止）的 Observable 序列
     */
    func never() {
        _ = Observable<Int>.never().subscribe {
            print($0)
        }
    }
    
    /**
     4，empty() 方法
     该方法创建一个空内容的 Observable 序列。
     */
    func empty() {
        _ = Observable<Int>.empty().subscribe {
            print($0)
        }
    }
    
    /**
     3，from() 方法
     （1）该方法需要一个数组参数。
     （2）下面样例中数据里的元素就会被当做这个 Observable 所发出 event 携带的数据内容，最终效果同上面饿 of() 样例是一样的。
     */
    func from() {
        let arr = ["a", "aa", "aaa"],
        _ = Observable.from(arr).subscribe({
            print($0)
        })
    }
    
    /**
     2，of() 方法
     （1）该方法可以接受可变数量的参数（必需要是同类型的）
     （2）下面样例中我没有显式地声明出 Observable 的泛型类型，Swift 也会自动推断类型。
     */
    func of() {
        _ = Observable.of("A", "B", "C").subscribe {
            print($0)
        }
    }
    
    /**
     1，just() 方法
     （1）该方法通过传入一个默认值来初始化。
     （2）下面样例我们显式地标注出了 observable 的类型为 Observable<Int>，即指定了这个 Observable 所发出的事件携带的数据类型必须是 Int 类型的。
     */
    func just() {
        _ = Observable<Int>.just(5).subscribe {
            print($0)
        }
    }
}
