//
//  VDControllerType.swift
//  VenusDriver
//
//  Created by Amit on 05/06/23.
//

import UIKit

protocol TDControllerType: UIViewController {
    associatedtype ViewModelType: TDViewModelProtocol
    func configure(with viewModel: ViewModelType)
    static func create() -> UIViewController
    func disableCompletionForEmptyInput()
}

extension TDControllerType {
    static func create(with viewModel: ViewModelType) -> UIViewController {
        return UIViewController()
    }

    func disableCompletionForEmptyInput() {}
}

protocol TDViewModelProtocol {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

protocol TDViewModelClassProtocol: AnyObject, TDViewModelProtocol {

}

extension TDViewModelClassProtocol {
    var memoryAddress: UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(self).toOpaque()
    }
}

extension UIViewController {
    var memoryAddress: UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(self).toOpaque()
    }
}
