//
//  DraggableViewController.swift
//  DaiUIKit
//
//  Created by daitran on 5/26/15.
//  Copyright (c) 2015 daitran. All rights reserved.
//

import UIKit
import Dkit_Dragdrop

class DraggableViewController: UIViewController, DKDraggableViewDelegate {

    @IBOutlet weak var apple:DKDraggableView!
    @IBOutlet weak var cart1: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apple.delegate = self
        apple.enableDragging = true
        apple.setDropTarget(cart1)
       

    }
    
    func onDropedToTarget(sender: DKDraggableView, target:UIView) {
        NSLog("Drop to target \(target.tag)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   }
