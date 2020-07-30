//
//  StoryboardViewController.swift
//  MaterialDesignWidgetsDemo
//
//  Created by Michael Ho on 5/28/20.
//  Copyright © 2020 Michael Ho. All rights reserved.
//

import UIKit

class StoryboardViewController: UIViewController {
    
    @IBOutlet weak var topSegmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    private var widgetsView: UIView!
    private var buttonsView: UIView!
    
    // loadView
    override func loadView() {
        super.loadView()
        
        widgetsView = WidgetsViewController().view
        buttonsView = ButtonsViewController().view
        self.contentView.addSubViews([widgetsView, buttonsView])
        
        widgetsView.setAnchors(top: self.contentView, bottom: self.contentView,
                               left: self.contentView, right: self.contentView)
        buttonsView.setAnchors(top: self.contentView, bottom: self.contentView,
                               left: self.contentView, right: self.contentView)
    }
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topSegmentedControl.selectedSegmentIndex = 0
        topSegmentDidChange(topSegmentedControl)
        self.hideKeyboardWhenTappedAround()
    }
    /**
     traitCollectionDidChange is called when user switch between dark and light mode. Whenever this is
     called, reset the UI.
     */
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        loadView()
        viewDidLoad()
    }
    
    @IBAction func topSegmentDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            contentView.bringSubviewToFront(widgetsView)
        case 1:
            contentView.bringSubviewToFront(buttonsView)
        default:
            break
        }
    }
}
