//
//  MaterialSegmentedControl.swift
//  MaterialDesignWidgets
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
            updateViews()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.5 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    public var textColor: UIColor = .gray {
        didSet {
            updateViews()
        }
    }
    
    public enum SelectorStyle {
        case fill
        case outline
        case line
    }
    public var selectorStyle: SelectorStyle = .line {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable
    public var selectorColor: UIColor = .gray {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable
    public var selectorTextColor: UIColor = .white {
        didSet {
            updateViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init(segments: [UIButton] = [], selectorStyle: SelectorStyle = .line, textColor: UIColor = .gray, selectorTextColor: UIColor = .white, selectorColor: UIColor = .gray, bgColor: UIColor = .clear) {
        self.init(frame: .zero)
        
        self.segments = segments
        self.selectorStyle = selectorStyle
        self.textColor = textColor
        self.selectorTextColor = selectorTextColor
        self.selectorColor = selectorColor
        self.backgroundColor = bgColor
    }
    
    func updateViews() {
        guard segments.count > 0 else { return }
        
        for idx in 0..<segments.count {
            segments[idx].backgroundColor = .clear
            segments[idx].addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            segments[idx].tag = idx
        }
        
        // Create a StackView
        stackView = UIStackView(arrangedSubviews: segments, axis: .horizontal, distribution: .fillEqually, spacing: 10.0)
        stackView.alignment = .fill
        
        selector = UIView(frame: .zero)
        if let first = segments.first {
            selector.setCornerBorder(cornerRadius: first.layer.cornerRadius)
        }
        
        switch selectorStyle {
        case .fill, .line:
            selector.backgroundColor = selectorColor
        case .outline:
            selector.setCornerBorder(color: selectorColor, borderWidth: 1.5)
        }
        
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        [selector, stackView].forEach { (view) in
            guard let view = view else { return }
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if let firstBtn = segments.first {
            buttonTapped(button: firstBtn)
        }
        
        self.layoutSubviews()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        selector.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        switch selectorStyle {
        case .fill, .outline:
            selector.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        case .line:
            selector.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        }
        
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
                moveView(selector, toX: btn.frame.origin.x)
            }
        }
        sendActions(for: .valueChanged)
    }
    
    /**
     Moves the view to the right position.
     
     - Parameter view:       The view to be moved to new position.
     - Parameter duration:   The duration of the animation.
     - Parameter completion: The completion handler.
     - Parameter toView:     The targetd view frame.
     */
    open func moveView(_ view: UIView, duration: Double = 0.5, completion: ((Bool) -> Void)? = nil, toX: CGFloat) {
        view.transform = CGAffineTransform(translationX: view.frame.origin.x, y: 0.0)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: { () -> Void in
                        view.transform = CGAffineTransform(translationX: toX, y: 0.0)
        }, completion: completion)
    }
}
