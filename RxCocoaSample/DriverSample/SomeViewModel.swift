//
//  SomeViewModel.swift
//  RxCocoaSample
//
//  Created by SwiftyCody on 2022/12/28.
//

import Foundation
import RxSwift
import RxCocoa

class SomeViewModel {
    
    let disposeBag = DisposeBag()
    
    // ViewModel -> View
    let labelText: Driver<String>
    
    // ViewModel <- View
    let switchIsOn = PublishRelay<Bool>()
    
    init() {
        labelText = switchIsOn
            .map { $0 ? "is On!" : "is Off!" }
            .asDriver(onErrorJustReturn: "error!")
    }
}
