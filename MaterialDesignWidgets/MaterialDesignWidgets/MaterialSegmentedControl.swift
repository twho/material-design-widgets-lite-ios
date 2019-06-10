//
//  CustomSegmentedContrl.swift
//  CustomSEgmentedControl
//
//  Created by Michael Ho on 06/09/19.
//  Copyright © 2019 Michael Ho. All rights reserved.
//

import UIKit

@IBDesignable
open class MaterialSegmentedControl: UIControl {
    
    public var selectedSegmentIndex = 0
    
    var stackView: UIStackView!
    open var selector: UIView!
    open var segments = [UIButton]() {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.5 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var textColor: UIColor = .gray {
        didSet {
            updateView()
        }
    }
    
    public enum SelectorStyle {
        case fill
        case line
    }
    var selectorStyle: SelectorStyle = .line {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var selectorColor: UIColor = .gray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var selectorTextColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init(segments: [UIButton], selectorStyle: SelectorStyle = .line, textColor: UIColor = .gray, selectorTextColor: UIColor = .white, selectorColor: UIColor = .gray) {
        self.init(frame: .zero)
        self.segments = segments
        self.selectorStyle = selectorStyle
        self.textColor = textColor
        self.selectorTextColor = selectorTextColor
        self.selectorColor = selectorColor
    }
    
    func updateView() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        for idx in 0..<segments.count {
            segments[idx].backgroundColor = .clear
            segments[idx].addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            segments[idx].tag = idx
        }
        if let firstBtn = segments.first {
            buttonTapped(button: firstBtn)
        }
        
        // Create a StackView
        stackView = UIStackView(arrangedSubviews: segments, axis: .horizontal, distribution: .fillProportionally, spacing: 10.0)
        stackView.alignment = .fill
        
        selector = UIView(frame: .zero)
        if let first = segments.first {
            selector.setCornerBorder(cornerRadius: first.layer.cornerRadius)
        }
        
        switch selectorStyle {
        case .fill:
            selector.backgroundColor = selectorColor
        case .line:
            selector.setCornerBorder(color: selectorColor, borderWidth: 1.5)
        }

        self.removeSubviews()
        self.addSubview(selector)
        selector.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.layoutSubviews()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        selector.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        selector.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        if let selector = selector, let first = stackView.arrangedSubviews.first {
            self.addConstraint(NSLayoutConstraint(item: selector, attribute: .width, relatedBy: .equal, toItem: first, attribute: .width, multiplier: 1.0, constant: 0.0))
        }
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.layoutIfNeeded()
    }
    
    @objc func buttonTapped(button: UIButton) {
        for (idx, btn) in segments.enumerated() {
            let image = btn.image(for: .normal)
            btn.setTitleColor(textColor, for: .normal)
            btn.setImage(image?.colored(textColor))
            
            if btn.tag == button.tag {
                selectedSegmentIndex = idx
                btn.setImage(image?.colored(selectorTextColor))
                btn.setTitleColor(selectorStyle == .line ? textColor : selectorTextColor, for: .normal)
                moveView(selector, from: selector.frame.origin, to: btn.frame.origin)
            }
        }
        sendActions(for: .valueChanged)
    }
    
    open func moveView(_ view: UIView, duration: Double = 0.5, completion: ((Bool) -> Void)? = nil,
                       from: CGPoint, to: CGPoint) {
        view.transform = CGAffineTransform(translationX: from.x, y: from.y)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: { () -> Void in
                        view.transform = CGAffineTransform(translationX: to.x, y: to.y)
        }, completion: completion)
    }
}
