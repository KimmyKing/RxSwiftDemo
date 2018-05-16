//
//  TraitsViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/15.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

//与数据相关的错误类型
enum DataError: Error {
    case cantParseJSON
}

//与缓存相关的错误类型
enum CacheError: Error {
    case failedCaching
}

//与缓存相关的错误类型
enum StringError: Error {
    case failedGenerate
}

class TraitsViewController: UIViewController {

    let bag = DisposeBag()
    
    lazy var textField:UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 30))
        textField.placeholder = "请输入"
        return textField
    }()
    
    
    lazy var label:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 30))
        return label
    }()
    
    lazy var button:UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 300, width: UIScreen.main.bounds.size.width, height: 30))
        btn.setTitle("绑定事件", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        /**
         1，基本介绍
         （1）ControlEvent 是专门用于描述 UI 所产生的事件，拥有该类型的属性都是被观察者（Observable）。
         （2）ControlEvent 和 ControlProperty 一样，都具有以下特征：
         不会产生 error 事件
         一定在 MainScheduler 订阅（主线程订阅）
         一定在 MainScheduler 监听（主线程监听）
         共享状态变化
         */
        _ = btn.rx.tap.subscribe(onNext: {
            print("用户行为事件绑定")
        })
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        view.addSubview(textField)

        view.addSubview(label)
        
        view.addSubview(button)
        
//        single()
        
//        asSingle()
        
//        completableExample()
        
//        mayBeExample()
        
//        asMaybe()
        
//        controlProperty()
        
    }
    
    /**
     1，基本介绍
     （1）ControlProperty 是专门用来描述 UI 控件属性，拥有该类型的属性都是被观察者（Observable）。
     （2）ControlProperty 具有以下特征：
     不会产生 error 事件
     一定在 MainScheduler 订阅（主线程订阅）
     一定在 MainScheduler 监听（主线程监听）
     共享状态变化
     */
    func controlProperty() {
        
        //将textField输入的文字绑定到label上
        _ = textField.rx.text.bind(to: label.rx.text)
    }
    
    /**
     我们可以通过调用 Observable 序列的 .asMaybe() 方法，将它转换为 Maybe。
     */
    func asMaybe() {
        _ = Observable.of(1).asMaybe().subscribe{
            print($0)
        }
    }
   
    /**
     1，基本介绍
     Maybe 同样是 Observable 的另外一个版本。它介于 Single 和 Completable 之间，它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件。
     发出一个元素、或者一个 completed 事件、或者一个 error 事件
     不会共享状态变化
     
     2，应用场景
     Maybe 适合那种可能需要发出一个元素，又可能不需要发出的情况。
     
     3，MaybeEvent
     为方便使用，RxSwift 为 Maybe 订阅提供了一个枚举（MaybeEvent）：
     .success：里包含该 Maybe 的一个元素值
     .completed：用于产生完成事件
     .error：用于产生一个错误
     */
    func mayBeExample() {
        _ = generateString().subscribe(onSuccess: {
            print("执行完毕,并获得元素\($0)")
        }, onError: {
            print("执行失败: \($0.localizedDescription)")
        }, onCompleted: {
            print("执行完毕,且没有任何元素")
        })
    }
    
    func generateString() -> Maybe<String> {
        
        return Maybe<String>.create { maybe in
            
            //成功并发出一个元素
//            maybe(.success("element"))
            
            //成功但不发出任何元素
//            maybe(.completed)
            
            //失败
            maybe(.error(StringError.failedGenerate))
            
            return Disposables.create {}
        }
        
    }
    
    
    /**
     1，基本介绍
     Completable 是 Observable 的另外一个版本。不像 Observable 可以发出多个元素，它要么只能产生一个 completed 事件，要么产生一个 error 事件。
     不会发出任何元素
     只会发出一个 completed 事件或者一个 error 事件
     不会共享状态变化
     
     2，应用场景
     Completable 和 Observable<Void> 有点类似。适用于那些只关心任务是否完成，而不需要在意任务返回值的情况。比如：在程序退出时将一些数据缓存到本地文件，供下次启动时加载。像这种情况我们只关心缓存是否成功。
     
     3，CompletableEvent
     为方便使用，RxSwift 为 Completable 订阅提供了一个枚举（CompletableEvent）：
     .completed：用于产生完成事件
     .error：用于产生一个错误
     */
    func completableExample(){
        
        _ = cacheLocally().subscribe(onCompleted: {
            print("保存成功")
        }, onError: { (error) in
            print("保存失败: \(error.localizedDescription)")
        })

    }
    
    func cacheLocally() -> Completable  {
        
        return Completable.create { completable in
            
            //将数据缓存到本地（这里掠过具体的业务代码，随机成功或失败）
            let success = (arc4random() % 2 == 0)
            
            guard success else {
                completable(.error(CacheError.failedCaching))
                return Disposables.create {}
            }
            
            completable(.completed)
            return Disposables.create {}
        }
        
    }
    
    
    /**
     我们可以通过调用 Observable 序列的 .asSingle() 方法，将它转换为 Single。
     */
    func asSingle() {
        _ = Observable.of("1")
            .asSingle()
            .subscribe({ print($0) })
    }
    
    /**
     1，基本介绍
     Single 是 Observable 的另外一个版本。但它不像 Observable 可以发出多个元素，它要么只能发出一个元素，要么产生一个 error 事件。
     发出一个元素，或一个 error 事件
     不会共享状态变化
     
     2，应用场景
     Single 比较常见的例子就是执行 HTTP 请求，然后返回一个应答或错误。不过我们也可以用 Single 来描述任何只有一个元素的序列。
     
     3，SingleEvent
     为方便使用，RxSwift 还为 Single 订阅提供了一个枚举（SingleEvent）：
     .success：里面包含该 Single 的一个元素值
     .error：用于包含错误
     */
    func single() {
        //获取第0个频道的歌曲信息
        _ = getPlayList("0")
            .subscribe { event in
                switch event {
                case .success(let json):
                    print("JSON结果: ", json)
                case .error(let error):
                    print("发生错误: ", error)
                }
        }
    }
    
    func getPlayList(_ channel: String) -> Single<[String : Any]> {
        
        return Single<[String: Any]>.create { single in
            
            let url = "https://douban.fm/j/mine/playlist?"
                + "type=n&channel=\(channel)&from=mainsite1"
            
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    //发送错误信息
                    single(.error(error))
                    return
                }
                
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data,
                                                                 options: .mutableLeaves),
                    let result = json as? [String: Any] else {
                        //发送错误信息
                        single(.error(DataError.cantParseJSON))
                        return
                }
                
                //发送接口数据
                single(.success(result))
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
        
        
    }
    

}
