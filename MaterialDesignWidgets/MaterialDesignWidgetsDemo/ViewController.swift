//
//  ViewController.swift
//  MaterialDesignWidgetsDemo
//
//  Created by Ho, Tsung Wei on 5/17/19.
//  Copyright © 2019 Michael Ho. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class ViewController: UIViewController {
    
    private var stackView: UIStackView!
    private let widgets: [WidgetType] = [
        .button,
        .textField,
        .loadingButton,
        .loadingIndicator,
        .shadowButton
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        stackView = UIStackView(axis: .vertical, distribution: .fillEqually, spacing: self.view.frame.height * 0.01)
        for type in widgets {
            let label = UILabel()
            label.text = type.rawValue
            label.textColor = .black
            stackView.addArrangedSubview(label)
            
            if type == .loadingButton, let loadingBtn = type.widget as? MaterialButton {
                loadingBtn.addTarget(self, action: #selector(tapLoadingButton(sender:)), for: .touchUpInside)
                stackView.addArrangedSubview(loadingBtn)
                continue
            }
            
            stackView.addArrangedSubview(type.widget)
        }
        self.view.addSubViews([stackView])
    }
    
    @objc func tapLoadingButton(sender: MaterialButton) {
        sender.isLoading = !sender.isLoading
        sender.isLoading ? sender.showLoader(userInteraction: true) : sender.hideLoader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.view.frame.height
        let width = self.view.frame.width
        self.stackView.setConstraintsToView(top: self.view, tConst: 0.1*height, bottom: self.view, bConst: -0.1*height, left: self.view, lConst: 0.05*width, right: self.view, rConst: -0.05*width)
        self.view.layoutIfNeeded()
    }
}

enum WidgetType: String {
    case button = "Material Design Button"
    case loadingButton = "Loading Button"
    case shadowButton = "Shadow Button"
    case textField = "Material Design TextField"
    case loadingIndicator = "Loading Indicator"
    
    var widget: UIView {
        switch self {
        case .button:
            let btnLeft = MaterialButton(text: "Normal Button", cornerRadius: 15.0)
            let btnRight = MaterialButton(text: "Normal Button", textColor: .black, bgColor: .white)
            btnRight.setCornerBorder(color: .black, cornerRadius: 15.0)
            let stack = UIStackView(arrangedSubviews: [btnLeft, btnRight], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
            return stack
        case .loadingButton:
            return MaterialButton(text: self.rawValue, cornerRadius: 15.0)
        case .shadowButton:
            let btnLeft = MaterialButton(text: self.rawValue, cornerRadius: 15.0, withShadow: true)
            let btnRight = MaterialButton(text: self.rawValue, textColor: .black, bgColor: .white, withShadow: true)
            btnRight.setCornerBorder(color: .black, cornerRadius: 15.0)
            let stack = UIStackView(arrangedSubviews: [btnLeft, btnRight], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
            return stack
        case .textField:
            return MaterialTextField(hint: "Material Design TextField", textColor: .black, bgColor: .white)
        case .loadingIndicator:
            let indicator = MaterialLoadingIndicator(radius: 15.0, color: .black)
            indicator.startAnimating()
            return indicator
        }
    }
}
