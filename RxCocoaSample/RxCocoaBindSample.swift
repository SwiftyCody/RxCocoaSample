//
//  ViewController.swift
//  RxCocoaSample
//
//  Created by SwiftyCody on 2022/12/24.
//

import UIKit
import SwiftUI
import SnapKit
import Then
import RxSwift
import RxCocoa

class RxCocoaBindSample: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let someLabel1 = UILabel().then {
        $0.text = "is On!"
    }
    
    let someLabel2 = UILabel().then {
        $0.text = "is On!"
    }
    
    let someLabel3 = UILabel().then {
        $0.text = "is On!"
    }
    
    let someSwitch1 = UISwitch().then {
        $0.isOn = true
    }
    
    let someSwitch2 = UISwitch().then {
        $0.isOn = true
    }
    
    let someSwitch3 = UISwitch().then {
        $0.isOn = true
    }
    
    let someLabel3Text = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        bind()
    }
    
    func attribute() {
        view.backgroundColor = .white
        
    }
    
    func layout() {
        [someLabel1, someLabel2, someLabel3, someSwitch1, someSwitch2, someSwitch3]
            .forEach { view.addSubview($0) }
        
        someLabel1.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        
        someLabel2.snp.makeConstraints {
            $0.top.equalTo(someLabel1.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        
        someLabel3.snp.makeConstraints {
            $0.top.equalTo(someLabel2.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        
        someSwitch1.snp.makeConstraints {
            $0.centerY.equalTo(someLabel1)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        someSwitch2.snp.makeConstraints {
            $0.centerY.equalTo(someLabel2)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        someSwitch3.snp.makeConstraints {
            $0.centerY.equalTo(someLabel3)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func bind() {
        someSwitch1.rx.isOn
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isOn in
                self?.someLabel1.text = isOn ? "is On!" : "is Off!"
            })
            .disposed(by: disposeBag)
        
        someSwitch2.rx.isOn
            .observe(on: MainScheduler.instance)
            .map { $0 ? "is On!" : "is Off!" }
            .bind(to: someLabel2.rx.text)
            .disposed(by: disposeBag)
        
        someLabel3Text
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] string in
                self?.someLabel3.text = string
            })
            .disposed(by: disposeBag)
        
        someSwitch3.rx.isOn
            .map { $0 ? "is On!" : "is Off!" }
            .bind(to: someLabel3Text)
            .disposed(by: disposeBag)
    }
}


// MARK: - for previews

struct RxCocoaBindSample_Previews: PreviewProvider {
    static var previews: some View {
        RxCocoaBindSampleRepresentable()
    }
}

struct RxCocoaBindSampleRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = RxCocoaBindSample()
        
        return UINavigationController(rootViewController: viewController)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}
