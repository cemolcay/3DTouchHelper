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
    var forceLayers = [ForceLayer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //basicExample()
        layerExample()
    }
}

extension ViewController { // Basic Example
    func basicExample() {
        add3DTouchGestureRecognizer { (touchIndex, state, force, normalizedForce, forceValue, location) in
            print("touch \(touchIndex) \(state) \(forceValue) value \(normalizedForce) at \(location)")
        }
    }
}

extension ViewController { // Layer Example
    func layerExample() {
        add3DTouchGestureRecognizer { (touchIndex, state, force, normalizedForce, touchForce, location) -> Void in
            if state == .Began {
                self.addLayer(touchIndex, position: location, normalizedForce: normalizedForce)
            } else if state == .Changed {
                self.updateLayer(touchIndex, position: location, normalizedForce: normalizedForce)
            } else if state == .Ended || state == .Cancelled {
                self.removeLayerAtIndex(touchIndex)
            }
        }
    }

    func addLayer(index: Int, position: CGPoint, normalizedForce: CGFloat) {
        let forceLayer = ForceLayer(position: position, normalizedForce: normalizedForce)
        forceLayers.append(forceLayer)
        view.layer.addSublayer(forceLayer)
    }

    func updateLayer(index: Int, position: CGPoint, normalizedForce: CGFloat) {
        let forceLayer = forceLayers[index]
        forceLayer.update(position, normalizedForce: normalizedForce)
    }

    func removeLayerAtIndex(index: Int) {
        let forceLayer = forceLayers[index]
        forceLayer.removeFromSuperlayer()
        forceLayers.removeAtIndex(index)
    }
}

class ForceLayer: CALayer {
    var maxRadius: CGFloat = 300

    init (position: CGPoint, normalizedForce: CGFloat) {
        super.init()
        self.borderColor = UIColor.blackColor().CGColor
        self.borderWidth = 0.5
        self.update(position, normalizedForce: normalizedForce)
    }

    override init(layer: AnyObject) {
        super.init(layer: layer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func update (position: CGPoint, normalizedForce: CGFloat) {
        let radius = getRadius(normalizedForce)
        self.frame = CGRectMake(0, 0, radius, radius)
        self.position = position
        self.cornerRadius = self.frame.size.width/2
    }

    private func getRadius(normalizedForce: CGFloat) -> CGFloat {
        return maxRadius * normalizedForce
    }
}
