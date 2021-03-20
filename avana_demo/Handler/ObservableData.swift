//
//  ObservableData.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation
import RxSwift

class ObservableData<DATA> {
    var value: DATA? = nil {
        didSet {
            observers.onNext(value)
        }
    }
    
    private let observers = PublishSubject<DATA?>()
    
    init(_ data: DATA? = nil) {
        self.value = data
    }
    
    func observe(_ disposeBag: DisposeBag, observer:  @escaping (DATA?) -> Void) {
        observers
            .subscribe(onNext: observer, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
