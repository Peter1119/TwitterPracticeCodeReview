//
//  Protocols.swift
//  TwitterPractice
//
//  Created by Sh Hong on 2022/12/07.
//

import UIKit
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    func transform(input: Input) -> Output
}

protocol ViewModelBindable {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension ViewModelBindable where Self: UIViewController {
    mutating func bind(viewModel: ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}

