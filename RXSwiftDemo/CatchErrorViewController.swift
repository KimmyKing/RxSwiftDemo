//
//  CatchErrorViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/15.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum MyError: Error {
    case A
    case B
}

class CatchErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
//        catchErrorJustReturn()
        
//        catchError()
        
        retry()
    }
    
    /**
     使用该方法当遇到错误的时候，会重新订阅该序列。比如遇到网络请求失败时，可以进行重新连接。
     retry() 方法可以传入数字表示重试次数。不传的话只会重试一次。
     */
    func retry() {
        
        var count = 1
        
        let errors = Observable<String>.create { observer in
            
            observer.onNext("a")
            observer.onNext("b")
        
            if count == 1 {
                observer.onError(MyError.A)
                print("Error encountered")
                count += 1
            }
            
            observer.onNext("c")
            observer.onNext("d")
            observer.onCompleted()
            
            return Disposables.create()
        }
        
         //重试2次（参数为空则只重试一次）
        _ = errors.retry(2).subscribe {
            print($0)
        }
        
    }
    
    /**
     该方法可以捕获 error，并对其进行处理。
     同时还能返回另一个 Observable 序列进行订阅（切换到新的序列）。
     */
    func catchError() {
        
        let fails = PublishSubject<String>()
        let recoverSequence = Observable.of("1", "2", "3")
        
        _ = fails.catchError {
            print("error: \($0)")
            return recoverSequence
            }.subscribe{
                print($0)
        }
        
        fails.onNext("a")
        fails.onNext("b")
        fails.onNext("c")
        //发送错误后,切换到recoverSequence序列
        fails.onError(MyError.A)
        fails.onNext("d")
    }
    
    /**
     当遇到 error 事件的时候，就返回指定的值，然后结束
     */
    func catchErrorJustReturn() {
        
        let fails = PublishSubject<String>()
        _ = fails.catchErrorJustReturn("错误").subscribe{
            print($0)
        }
        
        fails.onNext("a")
        fails.onNext("b")
        fails.onNext("c")
        fails.onError(MyError.A)
        fails.onNext("d")
    }
}
