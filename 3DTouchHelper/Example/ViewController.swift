//
//  ViewController.swift
//  3DTouchHelper
//
//  Created by Cem Olcay on 25/10/15.
//  Copyright © 2015 prototapp. All rights reserved.
//

import UIKit

extension UIGestureRecognizerState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .Began:
            return "Began"
        case .Cancelled:
            return "Cancel"
        case .Changed:
            return "Changed"
        case .Ended:
            return "Ended"
        case .Failed:
            return "Failed"
        case .Possible:
            return "Possible"
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        add3DTouchGestureRecognizer { (touchIndex, state, force, normalizedForce, forceValue, location) in
            print("touch \(touchIndex) \(state) \(forceValue) value \(normalizedForce) at \(location)")
        }
    }
}

