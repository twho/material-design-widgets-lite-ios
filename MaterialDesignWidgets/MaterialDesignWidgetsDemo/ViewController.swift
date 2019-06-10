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
    private var segmenteldControl: UISegmentedControl!
    private let widgets: [WidgetType] = [
        .textField,
        .segmentedControlLine,
        .segmentedControlFill,
        .loadingIndicator,
    ]
    
    private let buttons: [WidgetType] = [
        .button,
        .loadingButton,
        .verticalButton,
        .shadowButton
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        segmenteldControl = UISegmentedControl(items: ["All Widgets", "Buttons"])
        segmenteldControl.tintColor = .black
        segmenteldControl.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
        stackView = UIStackView(axis: .vertical, distribution: .fillEqually, spacing: self.view.frame.height * 0.01)
        self.view.addSubViews([segmenteldControl, stackView])
        
        segmenteldControl.selectedSegmentIndex = 0
        segmentDidChange(segmenteldControl)
    }
    
    private func reloadStackView(_ widgetTypes: [WidgetType]) {
        self.stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        for type in widgetTypes {
            let label = UILabel()
            label.text = type.rawValue
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 15.0)
            stackView.addArrangedSubview(label)
            
            if type == .loadingButton, let loadingBtn = type.widget as? MaterialButton {
                loadingBtn.addTarget(self, action: #selector(tapLoadingButton(sender:)), for: .touchUpInside)
                stackView.addArrangedSubview(loadingBtn)
            } else if (type == .segmentedControlLine || type == .segmentedControlFill),
                let segmentedControl = type.widget as? MaterialSegmentedControl {
                resetSegments(segmentedControl)
                stackView.addArrangedSubview(segmentedControl)
            } else {
                stackView.addArrangedSubview(type.widget)
            }
            
            if let last = stackView.arrangedSubviews.last {
                label.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.075).isActive = true
                last.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: type == .verticalButton ? 0.12 : 0.06).isActive = true
            }
        }
        self.view.layoutIfNeeded()
    }
    
    private func resetSegments(_ segmentedControl: MaterialSegmentedControl) {
        segmentedControl.segments = []
        for i in 0..<3 {
            // Set the corner radius to the half of the row height, button background needs to be clear.
            let button = MaterialButton(text: "Segment \(i)", textColor: .gray, bgColor: .clear, cornerRadius: 18.0)
            segmentedControl.segments.append(button)
        }
    }
    
    @objc func segmentDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            reloadStackView(widgets)
        case 1:
            reloadStackView(buttons)
        default:
            break
        }
    }
    
    @objc func tapLoadingButton(sender: MaterialButton) {
        sender.isLoading = !sender.isLoading
        sender.isLoading ? sender.showLoader(userInteraction: true) : sender.hideLoader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.view.frame.height
        let width = self.view.frame.width
        self.segmenteldControl.setConstraintsToView(top: self.view, tConst: 0.1*height, left: self.view, lConst: 0.05*width, right: self.view, rConst: -0.05*width)
        self.stackView.setConstraintsToView(left: self.view, lConst: 0.05*width, right: self.view, rConst: -0.05*width)
        self.segmenteldControl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        self.view.addConstraint(NSLayoutConstraint(item: self.stackView!, attribute: .top, relatedBy: .equal, toItem: segmenteldControl, attribute: .bottom, multiplier: 1.0, constant: 0.05*height))
        self.view.layoutIfNeeded()
    }
}

enum WidgetType: String {
    case button = "Material Design Button"
    case loadingButton = "Loading Button"
    case shadowButton = "Shadow Button"
    case verticalButton = "Vertical Aligned Button"
    case textField = "Material Design TextField"
    case loadingIndicator = "Loading Indicator"
    case segmentedControlLine = "Segmented Control - Line"
    case segmentedControlFill = "Segmented Control - Fill"
    
    var widget: UIView {
        switch self {
        case .button:
            let btnLeft = MaterialButton(text: "Button", cornerRadius: 15.0)
            let btnRight = MaterialButton(text: "Button", textColor: .black, bgColor: .white)
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
        case .verticalButton:
            let btn1 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_fill"), title: "Fill", foregroundColor: .black, bgColor: .white, cornerRadius: 18.0)
            let btn2 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_color"), title: "Color", foregroundColor: .black, useOriginalImg: true, bgColor: .white, cornerRadius: 18.0)
            let btn3 = MaterialVerticalButton(icon: #imageLiteral(resourceName: "ic_home_outline"), title: "Outline", foregroundColor: .white, bgColor: .black, cornerRadius: 18.0)
            let stack = UIStackView(arrangedSubviews: [btn1, btn2, btn3], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
            return stack
        case .textField:
            return MaterialTextField(hint: "Material Design TextField", textColor: .black, bgColor: .white)
        case .loadingIndicator:
            let indicatorBlack = MaterialLoadingIndicator(radius: 15.0, color: .black)
            let indicatorGray = MaterialLoadingIndicator(radius: 15.0, color: .gray)
            indicatorBlack.startAnimating()
            indicatorGray.startAnimating()
            let stack = UIStackView(arrangedSubviews: [indicatorBlack, indicatorGray], axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
            return stack
        case .segmentedControlLine, .segmentedControlFill:
            var segments = [UIButton]()
            let cornerRadius: CGFloat = 18.0
            for i in 0..<3 {
                // Button background needs to be clear, it will be set to clear in segmented control anyway.
                let button = MaterialButton(text: "Segment \(i)", textColor: .gray, bgColor: .clear, cornerRadius: cornerRadius)
                segments.append(button)
            }
            let segmentControl = MaterialSegmentedControl(segments: segments, selectorStyle: self == .segmentedControlLine ? .line : .fill, textColor: .black, selectorTextColor: .white, selectorColor: .black)
            segmentControl.backgroundColor = self == .segmentedControlLine ? .white : .lightGray
            if self == .segmentedControlFill {
                segmentControl.setCornerBorder(cornerRadius: cornerRadius)
            }
            return segmentControl
        }
    }
}
