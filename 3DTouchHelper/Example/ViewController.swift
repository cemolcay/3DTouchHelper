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
        case .began:
            return "Began"
        case .cancelled:
            return "Cancel"
        case .changed:
            return "Changed"
        case .ended:
            return "Ended"
        case .failed:
            return "Failed"
        case .possible:
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
            if state == .began {
                self.addLayer(touchIndex, position: location, normalizedForce: normalizedForce)
            } else if state == .changed {
                self.updateLayer(touchIndex, position: location, normalizedForce: normalizedForce)
            } else if state == .ended || state == .cancelled {
                self.removeLayerAtIndex(touchIndex)
            }
        }
    }

    func addLayer(_ index: Int, position: CGPoint, normalizedForce: CGFloat) {
        let forceLayer = ForceLayer(position: position, normalizedForce: normalizedForce)
        forceLayers.append(forceLayer)
        view.layer.addSublayer(forceLayer)
    }

    func updateLayer(_ index: Int, position: CGPoint, normalizedForce: CGFloat) {
        let forceLayer = forceLayers[index]
        forceLayer.update(position, normalizedForce: normalizedForce)
    }

    func removeLayerAtIndex(_ index: Int) {
        let forceLayer = forceLayers[index]
        forceLayer.removeFromSuperlayer()
        forceLayers.remove(at: index)
    }
}

class ForceLayer: CALayer {
    var maxRadius: CGFloat = 300

    init (position: CGPoint, normalizedForce: CGFloat) {
        super.init()
        self.borderColor = UIColor.black.cgColor
        self.borderWidth = 0.5
        self.update(position, normalizedForce: normalizedForce)
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func update (_ position: CGPoint, normalizedForce: CGFloat) {
        let radius = getRadius(normalizedForce)
        self.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        self.position = position
        self.cornerRadius = self.frame.size.width/2
    }

    fileprivate func getRadius(_ normalizedForce: CGFloat) -> CGFloat {
        return maxRadius * normalizedForce
    }
}
