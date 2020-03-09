//
//  Extensions.swift
//  MaterialDesignWidgetsDemo
//
//  Created by Ho, Tsung Wei on 5/18/19.
//  Copyright © 2019 Michael Ho. All rights reserved.
//

import UIKit

extension UIView {
    /**
     
     */
    public func setConstraintsToView(top: UIView? = nil, tConst: CGFloat = 0,
                                     bottom: UIView? = nil, bConst: CGFloat = 0,
                                     left: UIView? = nil, lConst: CGFloat = 0,
                                     right: UIView? = nil, rConst: CGFloat = 0) {
        guard let suView = self.superview else { return }
        
        if let top = top {
            suView.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: top, attribute: .top, multiplier: 1.0, constant: tConst))
        }
        
        if let bottom = bottom {
            suView.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: bottom, attribute: .bottom, multiplier: 1.0, constant: bConst))
        }
        
        if let left = left {
            suView.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: left, attribute: .left, multiplier: 1.0, constant: lConst))
        }
        
        if let right = right {
            suView.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: right, attribute: .right, multiplier: 1.0, constant: rConst))
        }
    }
    
    public func addSubViews(_ views: [UIView]) {
        views.forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
}

extension UIStackView {
    /**
     Convenience init 
     */
    convenience init(arrangedSubviews: [UIView]? = nil, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, spacing: CGFloat) {
        if let arrangedSubviews = arrangedSubviews {
            self.init(arrangedSubviews: arrangedSubviews)
        } else {
            self.init()
        }
        (self.axis, self.spacing, self.distribution) = (axis, spacing, distribution)
    }
}

extension UIViewController {
    /**
     Hide keyboard when tapping anywhere outside of textField in the view controller.
     */
    public func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    /**
     End all editing events in the view controller.
     */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
