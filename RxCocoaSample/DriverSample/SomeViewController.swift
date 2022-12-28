//
//  SomeViewController.swift
//  RxCocoaSample
//
//  Created by SwiftyCody on 2022/12/28.
//

import UIKit
import SwiftUI
import SnapKit
import Then
import RxSwift
import RxCocoa

class SomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var viewModel = SomeViewModel()
    
    let someLabel = UILabel().then {
        $0.text = "is On!"
    }
    
    let someSwitch = UISwitch().then {
        $0.isOn = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        bind(to: viewModel)
    }
    
    func attribute() {
        view.backgroundColor = .white
        
    }
    
    func layout() {
        [someLabel, someSwitch]
            .forEach { view.addSubview($0) }
        
        someLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        
        someSwitch.snp.makeConstraints {
            $0.centerY.equalTo(someLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func bind(to viewModel: SomeViewModel) {
        
        // ViewModel -> View
        viewModel.labelText
            .drive(someLabel.rx.text)
            .disposed(by: disposeBag)
        
        // ViewModel <- View
        someSwitch.rx.isOn
            .bind(to: viewModel.switchIsOn)
            .disposed(by: disposeBag)
    }
    
}



// MARK: - for previews

struct SomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        SomeViewControllerRepresentable()
    }
}

struct SomeViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = SomeViewController()
        
        return UINavigationController(rootViewController: viewController)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}
