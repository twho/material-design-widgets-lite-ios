//
//  Extensions.swift
//  MaterialDesignWidgets
//
//  Created by Ho, Tsung Wei on 5/16/19.
//  Copyright © 2019 Michael Ho. All rights reserved.
//

public typealias BtnAction = (()->())?

// MARK: - UIColor
extension UIColor {
    /**
     Convert RGB value to CMYK value.
     
     - Parameters:
     - r: The red value of RGB.
     - g: The green value of RGB.
     - b: The blue value of RGB.
     
     Returns a 4-tuple that represents the CMYK value converted from input RGB.
     */
    open func RGBtoCMYK(r: CGFloat, g: CGFloat, b: CGFloat) -> (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
        
        if r==0, g==0, b==0 {
            return (0, 0, 0, 1)
        }
        var c = 1 - r
        var m = 1 - g
        var y = 1 - b
        let minCMY = min(c, m, y)
        c = (c - minCMY) / (1 - minCMY)
        m = (m - minCMY) / (1 - minCMY)
        y = (y - minCMY) / (1 - minCMY)
        return (c, m, y, minCMY)
    }
    
    /**
     Convert CMYK value to RGB value.
     
     - Parameters:
     - c: The cyan value of CMYK.
     - m: The magenta value of CMYK.
     - y: The yellow value of CMYK.
     - k: The key/black value of CMYK.
     
     Returns a 3-tuple that represents the RGB value converted from input CMYK.
     */
    open func CMYKtoRGB(c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        let r = (1 - c) * (1 - k)
        let g = (1 - m) * (1 - k)
        let b = (1 - y) * (1 - k)
        return (r, g, b)
    }
    
    open func getColorTint() -> UIColor {
        let ciColor = CIColor(color: self)
        let originCMYK = RGBtoCMYK(r: ciColor.red, g: ciColor.green, b: ciColor.blue)
        let kVal = originCMYK.k > 0.3 ? originCMYK.k - 0.2 : originCMYK.k + 0.2
        let tintRGB = CMYKtoRGB(c: originCMYK.c, m: originCMYK.m, y: originCMYK.y, k: kVal)
        return UIColor(red: tintRGB.r, green: tintRGB.g, blue: tintRGB.b, alpha: 1.0)
    }
}

// MARK: - UIButton

extension UIButton {
    /**
     Set button image for all button states
     
     - Parameter image: The image to be set to the button.
     */
    open func setImage(_ image: UIImage?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setImage(image, for: state)
        }
    }
    /**
     Set button title for all button states
     
     - Parameter text: The text to be set to the button title.
     */
    open func setTitle(_ text: String?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setTitle(text, for: state)
        }
    }
}

// MARK: - UIImage

extension UIImage {
    /**
     Create color rectangle as image.
     
     - Parameter color: The color to be created as an UIImage
     - Parameter size:  The size of the UIImage, no need to be set when creating
     */
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil}
        self.init(cgImage: cgImage)
    }
    
    /**
     Change the color of the image.
     
     - Parameter color: The color to be set to the UIImage.
     
     Returns an UIImage with specified color
     */
    public func colored(_ color: UIColor?) -> UIImage? {
        if let newColor = color {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            
            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)
            
            newColor.setFill()
            context.fill(rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            newImage.accessibilityIdentifier = accessibilityIdentifier
            return newImage
        }
        return self
    }
}

// MARK: UIView

extension UIView {
    /**
     Set the corner radius of the view.
     
     - Parameter color:        The color of the border.
     - Parameter cornerRadius: The radius of the rounded corner.
     - Parameter borderWidth:  The width of the border.
     */
    open func setCornerBorder(color: UIColor? = nil, cornerRadius: CGFloat = 15.0, borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color != nil ? color!.cgColor : UIColor.clear.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    /**
     Set the shadow layer of the view.
     
     - Parameter bounds:       The bounds in CGRect of the shadow.
     - Parameter cornerRadius: The radius of the shadow path.
     - Parameter shadowRadius: The radius of the shadow.
     */
    open func setAsShadow(bounds: CGRect, cornerRadius: CGFloat = 0.0, shadowRadius: CGFloat = 1, color: UIColor) {
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
    }
    
    /**
     Remove all subviews.
     */
    public func removeSubviews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension UIStackView {
    
    /**
     Convenient initializer.
     
     - Parameter arrangedSubviews: all arranged subviews to be put to the stack.
     - Parameter axis: The arranged axis of the stack view.
     - Parameter distribution: The distribution of the stack view.
     - Parameter spacing: The spacing between each view in the stack view.
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
