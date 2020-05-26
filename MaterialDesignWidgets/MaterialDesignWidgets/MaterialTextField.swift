//
//  MaterialTextField.swift
//  MaterialDesignWidgets
//
//  Created by Le Van Nghia on 11/15/14.
//  Updated by Ho, Tsung Wei on 4/11/19.
//  Copyright © 2019 Michael T. Ho. All rights reserved.
//

import UIKit
import QuartzCore

open class MaterialTextField : UITextField {
    
    @IBInspectable open var padding: CGSize = CGSize(width: 5, height: 5)
    @IBInspectable open var floatingLabelBottomMargin: CGFloat = 2.0
    @IBInspectable open var floatingPlaceholderEnabled: Bool = false {
        didSet {
            self.updateFloatingLabelText()
        }
    }
    
    @IBInspectable open var maskEnabled: Bool = true {
        didSet {
            rippleLayer.maskEnabled = maskEnabled
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            rippleLayer.superLayerDidResize()
        }
    }
    @IBInspectable open var elevation: CGFloat = 0 {
        didSet {
            rippleLayer.elevation = elevation
        }
    }
    @IBInspectable open var shadowOffset: CGSize = CGSize.zero {
        didSet {
            rippleLayer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable open var roundingCorners: UIRectCorner = UIRectCorner.allCorners {
        didSet {
            rippleLayer.roundingCorners = roundingCorners
        }
    }
    @IBInspectable open var rippleEnabled: Bool = true {
        didSet {
            rippleLayer.rippleEnabled = rippleEnabled
        }
    }
    @IBInspectable open var rippleDuration: CFTimeInterval = 0.35 {
        didSet {
            rippleLayer.rippleDuration = rippleDuration
        }
    }
    @IBInspectable open var rippleScaleRatio: CGFloat = 1.0 {
        didSet {
            rippleLayer.rippleScaleRatio = rippleScaleRatio
        }
    }
    @IBInspectable open var rippleLayerColor: UIColor = .lightGray {
        didSet {
            rippleLayer.setRippleColor(color: rippleLayerColor)
        }
    }
    @IBInspectable open var backgroundAnimationEnabled: Bool = true {
        didSet {
            rippleLayer.backgroundAnimationEnabled = backgroundAnimationEnabled
        }
    }
    /**
     Bottom border configuration.
     */
    @IBInspectable open var bottomBorderEnabled: Bool = false {
        didSet {
            setupBottomBorder()
        }
    }
    /**
     Border width when the textField is not first responder.
     */
    @IBInspectable open var bottomBorderWidth: CGFloat = 1.5
    /**
     Border width when the textField is focused as first responder.
     */
    @IBInspectable open var bottomBorderHighlightWidth: CGFloat = 2.0
    /**
     Border color when the textField is not first responder. The highlighted bottom border color
     inherits from tintColor so it is consistent with caret cursor color.
    */
    @IBInspectable open var bottomBorderColor: UIColor = .lightGray {
        didSet {
            if bottomBorderEnabled {
                bottomBorderLayer?.backgroundColor = bottomBorderColor.cgColor
            }
        }
    }
    override open var bounds: CGRect {
        didSet {
            rippleLayer.superLayerDidResize()
        }
    }
    // floating label
    @IBInspectable open var floatingLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 10.0) {
        didSet {
            floatingLabel.font = floatingLabelFont
        }
    }
    @IBInspectable open var floatingLabelTextColor: UIColor = UIColor.lightGray {
        didSet {
            floatingLabel.textColor = floatingLabelTextColor
        }
    }
    override open var attributedPlaceholder: NSAttributedString? {
        didSet {
            updateFloatingLabelText()
        }
    }
    
    fileprivate lazy var rippleLayer: RippleLayer = RippleLayer(withView: self)
    fileprivate var floatingLabel: UILabel!
    fileprivate var bottomBorderLayer: CALayer?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    /**
     Convenience init of material design textfield with required information
     
     - Parameter placeholder:      the text to display as placeholder.
     - Parameter placeholderColor: the text color of placeholder.
     - Parameter textColor:        the text color of input in the textfield.
     - Parameter bgColor:          the background color of the textfield.
     - Parameter font:             the font of the textfield.
     - Parameter delegate:         the custom UITextFieldDelegate of the textfield.
     */
    public convenience init(placeholder: String, placeholderColor: UIColor = .lightGray,
                            textColor: UIColor, bgColor: UIColor, borderColor: UIColor? = nil,
                            font: UIFont? = nil,
                            delegate: UITextFieldDelegate? = nil) {
        self.init()
        setPlaceholder(placeholder)
        if let font = font {
            self.font = font
        }
        self.delegate = delegate
        self.textColor = textColor
        self.backgroundColor = bgColor
        if let borderColor = borderColor {
            self.bottomBorderEnabled = true
            self.bottomBorderColor = borderColor
            self.setupBottomBorder()
        }
    }
    /**
     Convenience init of material design textfield using system default colors. This initializer
     reflects dark mode colors on iOS 13 or later platforms. However, it will ignore any custom
     colors set to the textfield.
     
     - Parameter placeholder: the text to display as placeholder.
     - Parameter font:        the font of the textfield.
     - Parameter delegate:    the custom UITextFieldDelegate of the textfield.
     */
    @available(iOS 13.0, *)
    public convenience init(placeholder: String, font: UIFont? = nil, delegate: UITextFieldDelegate? = nil, bottomBorderEnabled: Bool) {
        self.init()
        if let font = font {
            self.font = font
        }
        self.delegate = delegate
        
        self.backgroundColor = .systemBackground
        self.textColor = .label
        setPlaceholder(placeholder, placeholderColor: .placeholderText)
        if bottomBorderEnabled {
            self.bottomBorderEnabled = true
            self.bottomBorderColor = .placeholderText
            self.setupBottomBorder()
        }
    }
    
    open func setPlaceholder(_ placeholder: String, placeholderColor: UIColor = .lightGray) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    fileprivate func setupLayer() {
        rippleLayer.elevation = self.elevation
        self.layer.cornerRadius = self.cornerRadius
        rippleLayer.elevationOffset = self.shadowOffset
        rippleLayer.roundingCorners = self.roundingCorners
        rippleLayer.maskEnabled = self.maskEnabled
        rippleLayer.rippleScaleRatio = self.rippleScaleRatio
        rippleLayer.rippleDuration = self.rippleDuration
        rippleLayer.rippleEnabled = self.rippleEnabled
        rippleLayer.backgroundAnimationEnabled = self.backgroundAnimationEnabled
        rippleLayer.setRippleColor(color: self.rippleLayerColor)
        
        layer.borderWidth = 0.0
        borderStyle = .none
        
        // floating label
        floatingLabel = UILabel()
        floatingLabel.font = floatingLabelFont
        floatingLabel.alpha = 0.0
        updateFloatingLabelText()
        
        addSubview(floatingLabel)
    }
    
    fileprivate func setupBottomBorder() {
        bottomBorderLayer?.removeFromSuperlayer()
        bottomBorderLayer = nil
        if bottomBorderEnabled {
            bottomBorderLayer = CALayer()
            bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - self.bottomBorderWidth,
                                              width: bounds.width, height: self.bottomBorderWidth)
            bottomBorderLayer?.backgroundColor = self.bottomBorderColor.cgColor
            layer.addSublayer(bottomBorderLayer!)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        bottomBorderLayer?.backgroundColor = isFirstResponder ? tintColor.cgColor : bottomBorderColor.cgColor
        let borderWidth = isFirstResponder ? bottomBorderHighlightWidth : bottomBorderWidth
        bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - borderWidth, width: layer.bounds.width, height: borderWidth)
        
        if !floatingPlaceholderEnabled {
            return
        }
        
        if let text = text , text.isEmpty == false {
            floatingLabel.textColor = isFirstResponder ? tintColor : floatingLabelTextColor
            if floatingLabel.alpha == 0 {
                showFloatingLabel()
            }
        } else {
            hideFloatingLabel()
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        var newRect = CGRect(x: rect.origin.x + padding.width, y: rect.origin.y,
                             width: rect.size.width - 2 * padding.width, height: rect.size.height)
        
        if !floatingPlaceholderEnabled {
            return newRect
        }
        
        if let text = text , text.isEmpty == false {
            let dTop = floatingLabel.font.lineHeight + floatingLabelBottomMargin
            newRect = newRect.inset(by: UIEdgeInsets(top: dTop, left: 0.0, bottom: 0.0, right: 0.0))
        }
        
        return newRect
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    // MARK: Touch
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        rippleLayer.touchesBegan(touches: touches, withEvent: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        rippleLayer.touchesEnded(touches: touches, withEvent: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        rippleLayer.touchesCancelled(touches: touches, withEvent: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        rippleLayer.touchesMoved(touches: touches, withEvent: event)
    }
}

// MARK - private methods

private extension MaterialTextField {
    func setFloatingLabelOverlapTextField() {
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch textAlignment {
        case .center:
            originX += textRect.size.width / 2 - floatingLabel.bounds.width / 2
        case .right:
            originX += textRect.size.width - floatingLabel.bounds.width
        default:
            break
        }
        floatingLabel.frame = CGRect(x: originX, y: padding.height, width: floatingLabel.frame.size.width, height: floatingLabel.frame.size.height)
    }
    
    func showFloatingLabel() {
        let curFrame = floatingLabel.frame
        floatingLabel.frame = CGRect(x: curFrame.origin.x, y: bounds.height / 2, width: curFrame.width, height: curFrame.height)
        UIView.animate(withDuration: 0.45, delay: 0.0, options: .curveEaseOut,
                       animations: {
                        self.floatingLabel.alpha = 1.0
                        self.floatingLabel.frame = curFrame
        }, completion: nil)
    }
    
    func hideFloatingLabel() {
        floatingLabel.alpha = 0.0
    }
    
    func updateFloatingLabelText() {
        floatingLabel.attributedText = attributedPlaceholder
        floatingLabel.sizeToFit()
        setFloatingLabelOverlapTextField()
    }
}
