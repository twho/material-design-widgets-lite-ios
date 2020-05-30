


## Material Design Widgets - Lightweight
This framework give you full flexibility to apply any material design widget you would like to use in your app! Please see below steps if you only need to use one or two of the entire package widgets. 

[![Generic badge](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/iOS-11.0+-blue.svg)](https://shields.io/)  [![Generic badge](https://img.shields.io/badge/Version-0.1.1-orange.svg)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/pod-1.9.2-lightgrey.svg)](https://shields.io/) [
![Generic badge](https://img.shields.io/badge/platform-ios-green.svg)](https://shields.io/) 

| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/overview-light.gif" alt="Overview" width="240"/> | <img src="gif/overview-dark.gif" alt="Overview Dark" width="240"/>  | 

You may download **MaterialDesignWidgetsDemo** to see how its used in your app. 

## Key Features
- A full package of material design widgets that you'll need to upgrade your app's visual.
- Widget classes are made to be **open**, which gives you flexibility to create your own.
- Instead of pull down the entire package, you can also copy the source of any widget you need independently.
- If you decide to just use one of the widgets, you can follow below **usage** for instructions on which files you need for that specific widget.

## Requirements
- Swift 5.0
- iOS 11.0+

## Installation

MaterialDesignWidgets is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
$ pod 'MaterialDesignWidgets'
```

If you don't use CocoaPods, you can download the entire project then drag and drop all the classes and use them in your project.

## Usage

### Buttons
> Required Files:
> - **RippleLayer.swift**
> - **MaterialButton.swift**

#### Normal Button
```swift
let btnSample1 = MaterialButton(text: "Sample1", cornerRadius: 15.0)
let btnSample2 = MaterialButton(text: "Sample2", textColor: .black, bgColor: .white)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/button-light.gif" alt="Button" width="350"/> | <img src="gif/button-dark.gif" alt="Button Dark" width="350"/> | 

#### Loading Button
```swift
let btnLoading = MaterialButton(text: "Loading Button", cornerRadius: 15.0)
loadingBtn.addTarget(self, action: #selector(tapLoadingButton(sender:)), for: .touchUpInside)

@objc func tapLoadingButton(sender: MaterialButton) {
    sender.isLoading = !sender.isLoading
    sender.isLoading ? sender.showLoader(userInteraction: true) : sender.hideLoader()
}
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/loadingbutton-light.gif" alt="Loading Button" width="350"/> | <img src="gif/loadingbutton-dark.gif" alt="Loading Button Dark" width="350"/> | 

#### Shadow Button
```swift
let btnShadow = MaterialButton(text: "Shadow Button", cornerRadius: 15.0, withShadow: true)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/shadowButton-light.gif" alt="Shadow Button" width="350"/> | <img src="gif/shadowButton-dark.gif" alt="Shadow Button Dark" width="350"/> | 

#### Vertical Aligned Button
```swift
let img = UIImage(named: "Your image name")
let btnV = MaterialVerticalButton(icon: img, title: "Fill", foregroundColor: .black, bgColor: .white)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/verticalButton-light.gif" alt="Vertical Aligned Button" width="350"/> | <img src="gif/verticalButton-dark.gif" alt="Vertical Aligned Button Dark" width="350"/> | 

### Segmented Control
>  Required File - **MaterialSegmentedControl.swift**

#### Filled
```swift
let sgFilled = MaterialSegmentedControl(selectorStyle: .fill, fgColor: .black, selectedFgColor: .white, selectorColor: .black, bgColor: .lightGray)
// Below is styling, you can write your own.
sgFilled.backgroundColor = .lightGray
sgFilled.setCornerBorder(cornerRadius: 18.0)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/segmentFill-light.gif" alt="Segmented Control Filled" width="350"/> | <img src="gif/segmentFill-dark.gif" alt="Segmented Control Filled Dark" width="350"/> | 

#### Outline
```swift
let sgOutline = MaterialSegmentedControl(selectorStyle: .outline, fgColor: .black, selectedFgColor: .black, selectorColor: .black, bgColor: .white)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/segmentOutline-light.gif" alt="Segmented Control Outline" width="350"/> | <img src="gif/segmentOutline-dark.gif" alt="Segmented Control Outline Dark" width="350"/> | 

#### Line Text
```swift
let sgLine = MaterialSegmentedControl(selectorStyle: .line, fgColor: .black, selectedFgColor: .black, selectorColor: .black, bgColor: .white)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/segmentLineText-light.gif" alt="Segmented Control Line Text" width="350"/> | <img src="gif/segmentLineText-dark.gif" alt="Segmented Control Line Text Dark" width="350"/> | 

#### Line Icon
```swift
let sgLineIcon = MaterialSegmentedControl(selectorStyle: .line, fgColor: .black, selectedFgColor: .black, selectorColor: .gray, bgColor: .white)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/segmentLineIcon-light.gif" alt="Segmented Control Line Icon" width="350"/> | <img src="gif/segmentLineIcon-dark.gif" alt="Segmented Control Line Icon Dark" width="350"/> | 

#### Append Normal Segment
```swift
for i in 0..<3 {
    segCtrl.appendSegment(text: "Segment \(i)", textColor: .gray, bgColor: .clear, cornerRadius: radius)
}
```

#### Append Icon Segment
```swift
let icons = [yourImage1, yourImage2, yourImage3]
for i in 0..<3 {
    sgLineIcon.appendIconSegment(icon: icons[i], preserveIconColor: true, rippleColor: .clear, cornerRadius: 0.0)
}
```

#### Add Value Change Listener
```swift
segCtrl.addTarget(self, action: #selector(yourSegmentedControlValueChangeMethod), for: .valueChanged)
```

### TextField
> Required files:
> - **RippleLayer.swift**
> - **MaterialTextField.swift**
```swift
let textField = MaterialTextField(hint: "TextField", textColor: .black, bgColor: .white)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/textField-light.gif" alt="TextField" width="350"/> | <img src="gif/textField-dark.gif" alt="TextField Dark" width="350"/> | 

### Loading Indicator
> Required file - **MaterialLoadingIndicator.swift**
```swift
let indicatorBlack = MaterialLoadingIndicator(radius: 15.0, color: .black)
indicatorBlack.startAnimating()
let indicatorGray = MaterialLoadingIndicator(radius: 15.0, color: .gray)
indicatorGray.startAnimating()
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/loading-light.gif" alt="Loading Indicator" width="350"/> | <img src="gif/loading-dark.gif" alt="Loading Indicator" width="350"/> | 

## Credits
* [Material Design](https://material.io/design/)
* [Le Van Nghia](https://github.com/sharad-paghadal/MaterialKit/tree/master/Source)
* [Icons8](https://icons8.com/)
