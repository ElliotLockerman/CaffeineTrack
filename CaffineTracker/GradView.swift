//
//  GradView.swift
//  CaffineTracker
//
//  Created by EL on 9/26/17.
//  Copyright © 2017 el. All rights reserved.
//

// Adapted from https://gist.github.com/R4ph-t/09443a9ece8a1bab37b6

import UIKit
@IBDesignable

class GradView: UIView {
    
    @IBInspectable var colorTop: UIColor? {
        didSet {
            layerGradient(colorTop: colorTop, colorBottom:colorBottom)
        }
    }
    
    @IBInspectable var colorBottom: UIColor? {
        didSet {
            layerGradient(colorTop: colorTop, colorBottom:colorBottom)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layerGradient(colorTop: colorTop, colorBottom:colorBottom)
    }
    
    func layerGradient(colorTop:UIColor?,colorBottom:UIColor?) {
        if colorTop != nil && colorBottom != nil{
            let layer : CAGradientLayer = CAGradientLayer()
            layer.frame = self.frame
            layer.colors = [colorTop!.cgColor,colorBottom!.cgColor]
            self.layer.insertSublayer(layer, at: 0)
        }
    }
    
}
