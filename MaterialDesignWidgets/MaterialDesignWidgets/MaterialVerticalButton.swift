//
//  MaterialVerticalButton.swift
//  MaterialDesignWidgets
//
//  Created by Le Van Nghia on 11/15/14.
//  Modified by Michael Ho on 4/11/19.
//  Copyright © 2019 Michael T. Ho. All rights reserved.
//
//  Ref: https://github.com/sharad-paghadal/MaterialKit/tree/master/Source

import UIKit

@IBDesignable
open class MaterialVerticalButton: UIControl {
    
    open var imageView: UIImageView!
    open var label: UILabel!
    
    private var imgHeightContraint: NSLayoutConstraint?
    
    @IBInspectable open var elevation: CGFloat = 0 {
        didSet {
            rippleLayer.elevation = elevation
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            rippleLayer.superLayerDidResize()
        }
    }
    @IBInspectable open var shadowOffset: CGSize = .zero {
        didSet {
            rippleLayer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable open var roundingCorners: UIRectCorner = UIRectCorner.allCorners {
        didSet {
            rippleLayer.roundingCorners = roundingCorners
        }
    }
    @IBInspectable open var maskEnabled: Bool = true {
        didSet {
            rippleLayer.maskEnabled = maskEnabled
        }
    }
    @IBInspectable open var rippleScaleRatio: CGFloat = 1.0 {
        didSet {
            rippleLayer.rippleScaleRatio = rippleScaleRatio
        }
    }
    @IBInspectable open var rippleDuration: CFTimeInterval = 0.35 {
        didSet {
            rippleLayer.rippleDuration = rippleDuration
        }
    }
    @IBInspectable open var rippleEnabled: Bool = true {
        didSet {
            rippleLayer.rippleEnabled = rippleEnabled
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
    
    override open var bounds: CGRect {
        didSet {
            rippleLayer.superLayerDidResize()
        }
    }
    /**
     Vertical button style for light mode and dark mode use. Only available on iOS 13 or later.
     */
    @available(iOS 13.0, *)
    public enum VerticalButtonStyle {
        case fill
        case outline
    }
    
    open lazy var rippleLayer: RippleLayer = RippleLayer(withView: self)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        defaultSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultSetup()
    }
    
    private func defaultSetup() {
        imageView = UIImageView()
        label = UILabel()
        setupLayer()
        addViews()
    }
    /**
     Convenience init of material design vertical aligned button with required parameters.
     
     - Parameter icon:            The icon of the button.
     - Parameter text:            The title of the button.
     - Parameter font:            The font of the button title.
     - Parameter foregroundColor: The foreground color of the button. It applies to title. It applies to icon if the useOriginalImg is false.
     - Parameter bgColor:         The background color of the button.
     - Parameter useOriginalImg:  To determine whether use the original button image or paint it with color.
     - Parameter cornerRadius:    The corner radius of the button. Used to set rounded corner.
    */
    public convenience init(icon: UIImage, text: String, font: UIFont? = nil,
                            foregroundColor: UIColor, bgColor: UIColor = .white,
                            useOriginalImg: Bool = false, cornerRadius: CGFloat = 0.0) {
        self.init()
        imageView = UIImageView(image: useOriginalImg ? icon : icon.colored(foregroundColor))
        label = UILabel()
        label.text = text
        label.textColor = foregroundColor
        label.textAlignment = .center
        if let font = font {
            label.font = font
        }
        self.cornerRadius = cornerRadius
        self.setCornerBorder(cornerRadius: cornerRadius)
        self.backgroundColor = bgColor
        setupLayer()
        addViews()
    }
    /**
     Convenience init of material design vertical aligned button using system default colors. This initializer
     reflects dark mode colors on iOS 13 or later platforms. However, it will ignore any custom colors
     set to the vertical aligned button.
     
     - Parameter icon:           The icon of the button.
     - Parameter text:           The title of the button.
     - Parameter font:           The font of the button title.
     - Parameter useOriginalImg: To determine whether use the original button image or paint it with color.
     - Parameter cornerRadius:   The corner radius of the button. Used to set rounded corner.
    */
    @available(iOS 13.0, *)
    public convenience init(icon: UIImage, text: String, font: UIFont? = nil,
                            useOriginalImg: Bool = false, cornerRadius: CGFloat = 0.0, buttonStyle: VerticalButtonStyle) {
        switch buttonStyle {
        case .fill:
            self.init(icon: icon, text: text, font: font, foregroundColor: .label, bgColor: .systemGray3,
                      useOriginalImg: useOriginalImg, cornerRadius: cornerRadius)
        case .outline:
            self.init(icon: icon, text: text, font: font, foregroundColor: .label, bgColor: .clear,
                      useOriginalImg: useOriginalImg, cornerRadius: cornerRadius)
            self.setCornerBorder(color: .label, cornerRadius: cornerRadius)
        }
    }
    
    open func addViews() {
        [label, imageView].forEach {
            self.addSubview($0.unsafelyUnwrapped)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
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
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width
        let height = self.frame.height
        imageView.contentMode = .scaleAspectFit
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.03*height).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.1*width).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.1*width).isActive = true
        if imgHeightContraint != nil {
            imgHeightContraint.unsafelyUnwrapped.isActive = false
        }
        imgHeightContraint = imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
        imgHeightContraint?.isActive = true
        
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0.05*height).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.1*width).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.1*width).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -0.03*height).isActive = true
        self.layoutIfNeeded()
    }
    
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
