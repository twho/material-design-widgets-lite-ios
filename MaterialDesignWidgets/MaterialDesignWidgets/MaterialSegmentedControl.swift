//
//  MaterialSegmentedControl.swift
//  MaterialDesignWidgets
//
//  Created by Michael Ho on 04/27/19.
//  Updated by Michael Ho on 05/27/20.
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
    
    @IBInspectable open var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.setCornerBorder(cornerRadius: cornerRadius)
        }
    }
    /**
     The foreground color of the segment.
     */
    @IBInspectable public var foregroundColor: UIColor = .gray {
        didSet {
            updateViews()
        }
    }
    /**
     The boolean to set whether the segment control displays the original color of the icon.
     */
    @IBInspectable public var preserveIconColor: Bool = false {
        didSet {
            updateViews()
        }
    }

    public enum SelectorStyle {
        case fill
        case outline
        case line
    }
    /**
     The selector UI type. See demo app for their looks.
     
     TODO: Will make it available in storyboard with @IBInspectable.
    */
     public var selectorStyle: SelectorStyle = .line {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable public var selectorColor: UIColor = .gray {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable public var selectedForegroundColor: UIColor = .white {
        didSet {
            updateViews()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /**
     Convenience initializer of MaterialSegmentedControl.
     
     - Parameter segments:        The segment in UIButton form.
     - Parameter selectorStyle:   The style of the selector, fill, outline and line are supported.
     - Parameter cornerRadius:    The corner radius of the segmented control. Used to crop rounded corner.
     - Parameter fgColor:         The foreground color of the non-selected segment.
     - Parameter selectedFgColor: The foreground color of the selected segment.
     - Parameter selectorColor:   The color of the selector.
     - Parameter bgColor:         Background color.
     */
    public convenience init(segments: [UIButton] = [], selectorStyle: SelectorStyle = .line, cornerRadius: CGFloat,
                            fgColor: UIColor, selectedFgColor: UIColor, selectorColor: UIColor, bgColor: UIColor) {
        self.init(frame: .zero)
        
        self.segments = segments
        self.selectorStyle = selectorStyle
        self.foregroundColor = fgColor
        self.selectedForegroundColor = selectedFgColor
        self.selectorColor = selectorColor
        self.backgroundColor = bgColor
        defer {
            self.cornerRadius = cornerRadius
        }
    }
    /**
     Convenience init of material design segmentedControl using system default colors. This initializer
     reflects dark mode colors on iOS 13 or later platforms. However, it will ignore any custom colors
     set to the segmentedControl.
     
     - Parameter segments:      The segment in UIButton form.
     - Parameter selectorStyle: The style of the selector, fill, outline and line are supported.
     - Parameter cornerRadius:  The corner radius of the segmented control. Used to crop rounded corner.
     */
    @available(iOS 13.0, *)
    public convenience init(segments: [UIButton] = [], selectorStyle: SelectorStyle = .line, cornerRadius: CGFloat) {
        self.init(frame: .zero)
        
        self.segments = segments
        self.selectorStyle = selectorStyle
        self.foregroundColor = .label
        self.selectedForegroundColor = .label
        switch selectorStyle {
        case .fill:
            self.selectorColor = .systemGray3
            self.backgroundColor = .systemFill
        default:
            self.selectorColor = .label
            self.backgroundColor = .systemBackground
        }
        defer {
            self.cornerRadius = cornerRadius
        }
    }
    
    open func appendIconSegment(icon: UIImage? = nil, preserveIconColor: Bool = true, rippleColor: UIColor) {
        self.preserveIconColor = preserveIconColor
        let button = MaterialButton(icon: icon, textColor: nil, bgColor: rippleColor, cornerRadius: self.cornerRadius)
        button.rippleLayerAlpha = 0.15
        self.segments.append(button)
    }
    
    open func appendSegment(icon: UIImage? = nil, text: String? = nil,
                            textColor: UIColor?, font: UIFont? = nil, rippleColor: UIColor) {
        let button = MaterialButton(icon: icon, text: text, textColor: textColor, bgColor: rippleColor, cornerRadius: self.cornerRadius)
        button.rippleLayerAlpha = 0.15
        self.segments.append(button)
    }
    
    open func appendTextSegment(text: String, textColor: UIColor?, font: UIFont? = nil,
                                rippleColor: UIColor) {
        self.appendSegment(text: text, textColor: textColor, font: font, rippleColor: rippleColor)
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
            selector.setCornerBorder(color: selectorColor, cornerRadius: selector.layer.cornerRadius, borderWidth: 1.5)
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
    // AutoLayout
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
            btn.setTitleColor(foregroundColor, for: .normal)
            btn.setImage(preserveIconColor ? image : image?.colored(foregroundColor))
            btn.isSelected = false
            
            if btn.tag == button.tag {
                selectedSegmentIndex = idx
                btn.isSelected = true
                btn.setImage(preserveIconColor ? image : image?.colored(selectedForegroundColor))
                btn.setTitleColor(selectorStyle == .line ? foregroundColor : selectedForegroundColor, for: .normal)
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
