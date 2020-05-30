//
//  WidgetsViewController.swift
//  MaterialDesignWidgetsDemo
//
//  Created by Michael Ho on 5/28/20.
//  Copyright © 2020 Michael Ho. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class WidgetsViewController: UIViewController {
    
    @IBOutlet weak var segmentedControlOutline: MaterialSegmentedControl!
    @IBOutlet weak var segmentedControlLineText: MaterialSegmentedControl!
    @IBOutlet weak var segmentedControlFill: MaterialSegmentedControl!
    @IBOutlet weak var segmentedControlLineIcon: MaterialSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up for outline segmented control
        segmentedControlOutline.selectorStyle = .outline
        setSampleSegments(segmentedControl: segmentedControlOutline, radius: 18.0)
        // Set up for line segmented control
        segmentedControlLineText.selectorStyle = .line
        setSampleSegments(segmentedControl: segmentedControlLineText, radius: 0.0)
        // Set up for fill segmented control
        segmentedControlFill.selectorStyle = .fill
        setSampleSegments(segmentedControl: segmentedControlFill, radius: 18.0)
        // Set up for icon segments
        let icons = [#imageLiteral(resourceName: "ic_home_fill").colored(.darkGray)!, #imageLiteral(resourceName: "ic_home_fill").colored(.gray)!, #imageLiteral(resourceName: "ic_home_fill").colored(.lightGray)!]
        for i in 0..<3 {
            segmentedControlLineIcon.appendIconSegment(icon: icons[i], preserveIconColor: true, rippleColor: .clear, cornerRadius: 0.0)
        }
    }
    /**
     Create sample segments for the segmented control.
     
     - Parameter segmentedControl: The segmented control to put these segments into.
     - Parameter cornerRadius:     The corner radius to be set to segments and selectors.
     */
    private func setSampleSegments(segmentedControl: MaterialSegmentedControl, radius: CGFloat) {
        for i in 0..<3 {
            segmentedControl.appendTextSegment(text: "Segment \(i)", textColor: .gray, rippleColor: .lightGray, cornerRadius: radius)
        }
    }
}
