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
     Set the anchors of current view. Make it align to the anchors of other views.
     
     - Parameter top:    The view as a reference for top anchor.
     - Parameter tConst: The constant to be applied to the top anchor.
     - Parameter bottom: The view as a reference for bottom anchor.
     - Parameter bConst: The constant to be applied to the bottom anchor.
     - Parameter left:   The view as a reference for left anchor.
     - Parameter lConst: The constant to be applied to the left anchor.
     - Parameter right:  The view as a reference for right anchor.
     - Parameter rConst: The constant to be applied to the right anchor.
     */
    public func setAnchors(top: UIView? = nil, tConst: CGFloat = 0,
                           bottom: UIView? = nil, bConst: CGFloat = 0,
                           left: UIView? = nil, lConst: CGFloat = 0,
                           right: UIView? = nil, rConst: CGFloat = 0) {
        // Set top anchor
        if let top = top {
            self.topAnchor.constraint(equalTo: top.topAnchor, constant: tConst).isActive = true
        }
        // Set bottom anchor
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom.bottomAnchor, constant: bConst).isActive = true
        }
        // Set left anchor
        if let left = left {
            self.leftAnchor.constraint(equalTo: left.leftAnchor, constant: lConst).isActive = true
        }
        // Set right anchor
        if let right = right {
            self.rightAnchor.constraint(equalTo: right.rightAnchor, constant: rConst).isActive = true
        }
    }
    /**
     Add subviews and make it prepared for AutoLayout.
     
     - Parameter views: The views to be added as subviews of current view.
    */
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
