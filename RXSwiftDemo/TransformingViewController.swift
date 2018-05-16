//
//  TransformingViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/14.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TransformingViewController: UIViewController {

    let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
//        buffer()
        
//        window()

//        map()
        
//        flatMap()
        
//        flatMapLatest()
        
//        flatMapFirst()
        
//        concatMap()

//        scan()
        
//        groupBy()
        
//        filter()
        
//        distincUnitChanged()
        
//        single()
        
//        elementAt()
        
//        ignoreElements()
        
//        take()
        
//        takeLast()
        
//        skip()
        
//        sample()
        
//        debounce()
        
//        amb()
        
//        takeWhile()
        
//        takeUntil()
        
//        skipWhile()
        
//        skipUntil()
        
//        startWith()
        
//        merge()
        
//        zip()
        
//        combineLatest()
        
//        withLatestFrom()
        
//        switchLatest()
        
//        toArray()
        
//        reduce()
        
//        concat()
        
//        publish()
        
//        replay()
        
//        multicast()
        
//        refCount()
        
//        share()
        
//        dealy()
        
//        dealySubscription()
        
//        materialize()
        
//        dematerialize()
        
        timeout()  
        
    }
    
    /**
     使用该操作符可以设置一个超时时间。如果源 Observable 在规定时间内没有发任何出元素，就产生一个超时的 error 事件。
     */
    func timeout() {
        
        //定义好每个事件里的值以及发送的时间
        let times = [
            [ "value": 1, "time": 0 ],
            [ "value": 2, "time": 0.5 ],
            [ "value": 3, "time": 1.5 ],
            [ "value": 4, "time": 4 ],
            [ "value": 5, "time": 5 ]
        ]
        
        _ = Observable.from(times).flatMap { item in
            
            return Observable.of(Int(item["value"]!)).delaySubscription(Double(item["time"]!),scheduler: MainScheduler.instance)
            
            //超过2秒未发出事件,就发送error事件
            }.timeout(2, scheduler: MainScheduler.instance).subscribe(onNext: { (element) in
                print(element)
            }, onError: { (error) in
                print(error)
            })
        
        
    }
    
    /**
     该操作符的作用和 materialize 正好相反，它可以将 materialize 转换后的元素还原
     */
    func dematerialize() {
        _ = Observable.of(1, 2, 3).materialize().dematerialize().subscribe{
            print($0)
        }
    }
    
    /**
     该操作符可以将序列产生的事件，转换成元素。
     通常一个有限的 Observable 将产生零个或者多个 onNext 事件，最后产生一个 onCompleted 或者 onError 事件。而 materialize 操作符会将 Observable 产生的这些事件全部转换成元素，然后发送出来。
     */
    func materialize() {
        _ = Observable.of(1, 2, 3).materialize().subscribe{
            print($0)
        }
    }
    
    /**
     使用该操作符可以进行延时订阅。即经过所设定的时间后，才对 Observable 进行订阅操作。
     */
    func dealySubscription() {
        _ = Observable.of(1, 2, 3).delaySubscription(3, scheduler: MainScheduler.instance).subscribe{
            print($0)
        }
    }
    
    /**
     该操作符会将 Observable 的所有元素都先拖延一段设定好的时间，然后才将它们发送出来。
     */
    func dealy() {
        _ = Observable.of(1, 2, 1).delay(3, scheduler: MainScheduler.instance).subscribe{
            print($0)
        }
    }
    
    /**
     该操作符将使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者。
     简单来说 shareReplay 就是 replay 和 refCount 的组合。
     */
    func share() {
        
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).share(replay: 1)
        
        _ = interval.subscribe{
            print("订阅1: \($0)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            _ = interval.subscribe{
                print("订阅2: \($0)")
            }
        }
    }
    
    /**
     refCount 操作符可以将可被连接的 Observable 转换为普通 Observable
     即该操作符可以自动连接和断开可连接的 Observable。当第一个观察者对可连接的 Observable 订阅时，那么底层的 Observable 将被自动连接。当最后一个观察者离开时，那么底层的 Observable 将被自动断开连接。
     */
    func refCount() {
        
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish().refCount()
        
        _ = interval.subscribe {
            print("订阅1: \($0)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            _ = interval.subscribe{
                print("订阅2: \($0)")
            }
        }
    }
    
    /**
     multicast 方法同样是将一个正常的序列转换成一个可连接的序列。
     同时 multicast 方法还可以传入一个 Subject，每当序列发送事件时都会触发这个 Subject 的发送。
     */
    func multicast() {
        
        let subject = PublishSubject<Int>()
        
        _ = subject.subscribe{
            print("subject: \($0)")
        }
        
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).multicast(subject)
        
        _ = interval.subscribe{
            print("订阅1: \($0)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //connect之后才会发送消息,同时subject也会发送
            _ = interval.connect()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            _ = interval.subscribe{
                //10秒后开始订阅
                print("订阅2: \($0)")
            }
        }
    }
    
    /**
     replay 同上面的 publish 方法相同之处在于：会将将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
     replay 与 publish 不同在于：新的订阅者还能接收到订阅之前的事件消息（数量由设置的 bufferSize 决定）。
     */
    func replay() {
        
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).replay(1)
        
        _ = interval.subscribe{
            print("订阅1: \($0)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            _ = interval.connect()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            _ = interval.subscribe{
                print("订阅2: \($0)")
            }
        }
    }
    
    /**
     publish 方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
     */
    func publish() {
        
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()
        
        //第一个订阅者（立刻开始订阅）
        _ = interval.subscribe{
            print("订阅1: \($0)")
        }.disposed(by: bag)
        
        //相当于把事件消息推迟了5秒
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
            _ = interval.connect().disposed(by: self.bag)
        }
        
        //第二个订阅者（延迟15秒开始订阅)
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            _ = interval.subscribe{
                print("订阅2: \($0)")
            }.disposed(by: self.bag)
        }
    }
    
    /**
     concat 会把多个 Observable 序列合并（串联）为一个 Observable 序列。
     并且只有当前面一个 Observable 序列发出了 completed 事件，才会开始发送下一个 Observable 序列事件。
     */
    func concat() {
        
        let subject1 = BehaviorSubject(value: 1)
        let subject2 = BehaviorSubject(value: 2)
        
        let variable = Variable(subject1)
        
        _ = variable.asObservable().concat().subscribe{
            print($0)
        }
        subject2.onNext(2)
        subject1.onNext(1)
        subject1.onNext(1)
        subject1.onCompleted()
        
        variable.value = subject2
        subject2.onNext(2)
    }
    
    /**
     reduce 接受一个初始值，和一个操作符号。
     reduce 将给定的初始值，与序列里的每个值进行累计运算。得到一个最终结果，并将其作为单个值发送出去。
     */
    func reduce() {
        _ = Observable.of(1, 2, 3, 4, 5).reduce(0, accumulator: +).subscribe{
            print($0)
        }
    }
    
    /**
     该操作符先把一个序列转成一个数组，并作为一个单一的事件发送，然后结束。
     */
    func toArray() {
        _ = Observable.of(1, 2, 3).toArray().subscribe{
            print($0)
        }
    }
    
    /**
     switchLatest 有点像其他语言的 switch 方法，可以对事件流进行转换。
     比如本来监听的 subject1，我可以通过更改 variable 里面的 value 更换事件源。变成监听 subject2。
     */
    func switchLatest() {
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        _ = variable.asObservable().switchLatest().subscribe{
            print($0)
        }
        
        subject1.onNext("B")
        subject1.onNext("C")
        
        //改变事件源
        variable.value = subject2
        subject1.onNext("D")
        subject2.onNext("2")
        
        //改变事件源,会重新发送最新的默认值
        variable.value = subject1
        subject2.onNext("3")
        subject1.onNext("E")
    }
    
    /**
     该方法将两个 Observable 序列合并为一个。每当 self 队列发射一个元素时，便从第二个序列中取出最新的一个值。
     */
    func withLatestFrom() {
        
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        _ = subject1.withLatestFrom(subject2).subscribe{
            print($0)
        }
        
        //subject2序列中没有值,不发送
        subject1.onNext("A")
        subject2.onNext("1")
        
        //subject2序列中有值,发送最新的
        subject1.onNext("B")
        subject1.onNext("C")
        subject2.onNext("2")
        subject1.onNext("D")
    }
    
    /**
     该方法同样是将多个（两个或两个以上的）Observable 序列元素进行合并。
     但与 zip 不同的是，每当任意一个 Observable 有新的事件发出时，它会将每个 Observable 序列的最新的一个事件元素进行合并。
     */
    func combineLatest() {
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        _ = Observable.combineLatest(subject1, subject2) {
            "\($0)\($1)"
            }.subscribe{
                print($0)
        }
    
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
    }
    
    /**
     该方法可以将多个（两个或两个以上的）Observable 序列压缩成一个 Observable 序列。
     而且它会等到每个 Observable 事件一一对应地凑齐之后再合并。
     zip 常常用在整合网络请求上。
     比如我们想同时发送两个请求，只有当两个请求都成功后，再将两者的结果整合起来继续往下处理。这个功能就可以通过 zip 来实现。
     */
    func zip() {
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        _ = Observable.zip(subject1, subject2) {
            "\($1)\($0)"
            }.subscribe{
                print($0)
        }
        
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        
        //subject2没有对应的消息,不会发送
        subject1.onNext(5)

        
//        //第一个请求
//        let userRequest: Observable<User> = API.getUser("me")
//
//        //第二个请求
//        let friendsRequest: Observable<Friends> = API.getFriends("me")
//
//        //将两个请求合并处理
//        Observable.zip(userRequest, friendsRequest) {
//            user, friends in
//            //将两个信号合并成一个信号，并压缩成一个元组返回（两个信号均成功）
//            return (user, friends)
//
//            }.observeOn(MainScheduler.instance) //加这个是应为请求在后台线程，下面的绑定在前台线程。
//            .subscribe(onNext: { (user, friends) in
//                //将数据绑定到界面上
//                //.......
//            })
    }
    
    /**
     该方法可以将多个（两个或两个以上的）Observable 序列合并成一个 Observable 序列
     */
    func merge() {
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        
        _ = Observable.of(subject1, subject2).merge().subscribe{
            print($0)
        }
        
        subject1.onNext(1)
        subject2.onNext(2)
        subject1.onNext(3)
        subject2.onNext(4)
    }
    
    /**
     该方法会在 Observable 序列开始之前插入一些事件元素。即发出事件消息之前，会先发出这些预先插入的事件消息
     */
    func startWith() {
        _ = Observable.of(2, 3).startWith(1, 0).startWith(9).subscribe{
            print($0)
        }
    }
    
    /**
     同上面的 takeUntil 一样，skipUntil 除了订阅源 Observable 外，通过 skipUntil 方法我们还可以监视另外一个 Observable， 即 notifier 。
     与 takeUntil 相反的是。源 Observable 序列事件默认会一直跳过，直到 notifier 发出值或 complete 通知。
     */
    func skipUntil() {
        
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<Int>()
        _ = source.skipUntil(notifier).subscribe{
            print($0)
        }
        source.onNext(1)
        source.onNext(2)
        source.onNext(3)
        source.onNext(4)
        source.onNext(5)
        
        //source开始接收消息
        notifier.onNext(0)
        
        source.onNext(6)
        source.onNext(7)
        source.onNext(8)
        
        //source仍然接收消息
        notifier.onNext(0)
        
        source.onNext(9)
    }
    
    /**
     该方法用于跳过前面所有满足条件的事件。
     一旦遇到不满足条件的事件，之后就不会再跳过了。
     */
    func skipWhile() {
        _ = Observable.of(2, 3, 4, 5, 6).skipWhile{$0 < 4}.subscribe{
            print($0)
        }
    }
    
    /**
     除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier。
     如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件。
     */
    func takeUntil() {
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
        _ = source.takeUntil(notifier).subscribe{
            print($0)
        }
        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")
        
        //notifer发送消息之后,source就停止发送事件
        notifier.onNext("z")
        
        source.onNext("e")
        source.onNext("f")
    }
    
    /**
     该方法依次判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成。
     */
    func takeWhile() {
        _ = Observable.of(2, 3, 4, 5, 6).takeWhile { $0 < 4 }.subscribe{
            print($0)
        }
    }
    
    /**
     当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables。
     */
    func amb() {
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
        
        _ = subject1.amb(subject2).amb(subject3).subscribe{
            print($0)
        }
        
        //第一个消息是subject2发送的,之后只发送subject2的消息
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(0)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(0)
        subject3.onNext(0)
        
    }
    
    /**
     debounce 操作符可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生。
     换句话说就是，队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。
     debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件。
     */
    func debounce() {
        
        //定义好每个事件里的值以及发送的时间
        let times = [
            [ "value": 1, "time": 0.1 ],
            [ "value": 2, "time": 1.1 ],
            [ "value": 3, "time": 0.2 ],
            [ "value": 4, "time": 1.2 ],
            [ "value": 5, "time": 1.4 ],
            [ "value": 6, "time": 5.1 ]
        ]
        
        _ = Observable.from(times).flatMap { item -> Observable<Int> in
            
            print(item)
            
            //每个事件都延时time秒
            return Observable.of(Int(item["value"]!)).delaySubscription(Double(item["time"]!), scheduler: MainScheduler.instance)
        
            }.debounce(0.5, scheduler: MainScheduler.instance).subscribe { //只发出与下一个间隔超过0.5秒的元素,不关心序列顺序
                print($0)
        }
    }
    
    /**
     Sample 除了订阅源 Observable 外，还可以监视另外一个 Observable， 即 notifier 。
     每当收到 notifier 事件，就会从源序列取一个最新的事件并发送。而如果两次 notifier 事件之间没有源序列的事件，则不发送值。
     */
    func sample() {
        
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        _ = source.sample(notifier).subscribe{
            print($0)
        }
        
        //源序列存储的事件
        source.onNext(1)
        //notifier发送事件后,源序列就会取一个最新的事件并发送
        notifier.onNext("A")
        
        source.onNext(2)

        notifier.onNext("B")

        //两次notifier事件之间没有源序列的事件,不发送
        notifier.onNext("C")

        source.onNext(3)

        source.onNext(4)

        //只发送最新的一个事件
        notifier.onNext("D")

        source.onNext(5)

        notifier.onCompleted()
    }
    
    /**
     该方法用于跳过源 Observable 序列发出的前 n 个事件
     */
    func skip() {
        _ = Observable.of(1, 2, 3, 4).skip(2).subscribe{
            print($0)
        }
    }
    
    /**
     该方法实现仅发送 Observable 序列中的后 n 个事件。
     */
    func takeLast() {
        _ = Observable.of(1, 2, 3, 4).takeLast(2).subscribe {
            print($0)
        }
    }
    
    /**
     该方法实现仅发送 Observable 序列中的前 n 个事件，在满足数量之后会自动 .completed。
     */
    func take() {
        _ = Observable.of(1, 2, 3, 4).take(2).subscribe{
            print($0)
        }
    }
    
    /**
     该操作符可以忽略掉所有的元素，只发出 error 或 completed 事件。
     如果我们并不关心 Observable 的任何元素，只想知道 Observable 在什么时候终止，那就可以使用 ignoreElements 操作符。
     */
    func ignoreElements() {
        _ = Observable.of(1, 2, 3, 4).ignoreElements().subscribe{
            print($0)
        }
    }
    
    /**
     该方法实现只处理在指定位置的事件。
     */
    func elementAt() {
        //处理第二个事件
        _ = Observable.of(1, 2, 3, 4).elementAt(2).subscribe{
            print($0)
        }
    }
    
    /**
     限制只发送一次事件，或者满足条件的第一个事件。
     如果存在有多个事件或者没有事件都会发出一个 error 事件。
     如果只有一个事件，则不会发出 error 事件。
     */
    func single() {
        _ = Observable.of(1, 2, 3, 4).single {
            $0 == 2
            }.subscribe {
            print($0)
        }
        
//        _ = Observable.of("A", "B", "C", "D").single().subscribe{
//            print($0)
//        }
    }
    
    /**
     该操作符用于过滤掉'连续'重复的事件。
     */
    func distincUnitChanged() {
        _ = Observable.of(1, 2, 3, 1, 1, 1, 4).distinctUntilChanged().subscribe {
            print($0)
        }
    }
    
    /**
     该操作符就是用来过滤掉某些不符合要求的事件。
     */
    func filter() {
        _ = Observable.of(2, 30, 22, 5, 1, 34).filter{$0 > 10}.subscribe(onNext:{
            print($0)
        })
    }
    
    /**
     groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来。
     也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来。
     */
    func groupBy() {
        
        _ = Observable<Int>.of(0, 1, 2, 3, 4, 5).groupBy(keySelector: { (element) -> String in
            return element % 2 == 0 ? "偶数" : "奇数"
        }).subscribe({ (event) in
            
            switch event {
                
            case .next(let group):
                _ = group.asObservable().subscribe({ (event) in
                    print("key: \(group.key), event:\(event)")
                })
            case .error(_): break
                
            case .completed: break
                
            }
        })
    }
    
    /**
     scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作。
     */
    func scan() {
        _ = Observable.of(1, 2, 3, 4, 5).scan(0) { numA, numB in
                numA + numB
            }.subscribe(onNext: {
                print($0)
            })
    }
    
    /**
     concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
     */
    func concatMap() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        _ = variable.asObservable().concatMap {$0}.subscribe(onNext: {
            print($0)
        })
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
        //只有前一个序列结束后，才能接收下一个序列
        subject1.onCompleted()
    }
    
    /**
     flatMapFirst 与 flatMapLatest 正好相反：flatMapFirst 只会接收最初的 value 事件。
     */
    func flatMapFirst() {
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        _ = variable.asObservable().flatMapFirst {$0}.subscribe(onNext: {
            print($0)
        })
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    /**
     flatMapLatest 与 flatMap 的唯一区别是：flatMapLatest 只会接收最新的 value 事件。
     */
    func flatMapLatest() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        _ = variable.asObservable().flatMapLatest {$0}.subscribe(onNext: {
            print($0)
        })
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    /**
     map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列。
     而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
     这个操作符是非常有用的。比如当 Observable 的元素本生拥有其他的 Observable 时，我们可以将所有子 Observables 的元素发送出来。
     */
    func flatMap() {
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        _ = variable.asObservable().flatMap {$0}.subscribe(onNext: {
            print($0)
        })
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }

    /**
     该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列。
     */
    func map() {
        _ = Observable.of(1, 2, 3).map{$0 * 10}.subscribe(onNext: {
            print($0)
        })
    }
    
    /**
     window 操作符和 buffer 十分相似。不过 buffer 是周期性的将缓存的元素集合发送出来，而 window 周期性的将元素集合以 Observable 的形态发送出来。
     同时 buffer 要等到元素搜集完毕后，才会发出元素序列。而 window 可以实时发出元素序列。
     */
    func window() {
        
        let subject = PublishSubject<String>()
        //每3个元素作为一个子Observable发出。
        _ = subject.window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance).subscribe(onNext: {
            print("subscribe:  \($0)")
            
            _ = $0.asObservable().subscribe({
                print($0)
            })
        }).disposed(by: bag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
    }
    
    /**
     buffer 方法作用是缓冲组合，第一个参数是缓冲时间，第二个参数是缓冲个数，第三个参数是线程。
     该方法简单来说就是缓存 Observable 中发出的新元素，当元素达到某个数量，或者经过了特定的时间，它就会将这个元素集合发送出来。
     */
    func buffer() {
        
        let subject = PublishSubject<String>()
        //每缓存3个元素则组合起来一起发出。
        //如果1秒钟内不够3个也会发出（有几个发几个，一个都没有发空数组 []）
        _ = subject.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance).subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
    }

}
