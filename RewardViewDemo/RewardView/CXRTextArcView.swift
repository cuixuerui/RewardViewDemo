//
//  CXRTextArcView.swift
//  RewardViewDemo
//
//  Created by cuixuerui on 2019/4/9.
//  Copyright © 2019 cuixuerui. All rights reserved.
//

import UIKit

class CXRTextArcView: UIView {
    
    internal var text: String? {
        didSet { setNeedsDisplay() }
    }
    internal var textAttributes: Dictionary<NSAttributedString.Key, Any>? {
        didSet { setNeedsDisplay() }
    }
    /**
     *  Text NSTextAlignment
     */
    internal var textAlignment: NSTextAlignment = .natural {
        didSet { setNeedsDisplay() }
    }
    /**
     *  Text 在边界的垂直位置
     */
    internal var verticalTextAlignment: VerticalAlignment = .center {
        didSet { setNeedsDisplay() }
    }
    /**
     *  调整半径
     */
    internal var radius: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    /**
     *  基础角度
     */
    internal var baseAngle: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    /**
     *  调整字符间距
     *  1 = default spacing, 0.5 = half spacing, 2 = double spacing, etc ...
     */
    internal var characterSpacing: CGFloat = 1 {
        didSet {
            if characterSpacing < 0 { characterSpacing = 1 }
            setNeedsDisplay()
        }
    }
    
    private var circleCenter: CGPoint = .zero
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        circleCenter = CGPoint(x: bounds.size.width/2, y: bounds.size.height)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard
            let text = text,
            let context = UIGraphicsGetCurrentContext() else {
                return
        }
        let stringSize = NSString(string: text).size(withAttributes: textAttributes)
        let maxRadius = maximumRadius(size: stringSize, vertical: verticalTextAlignment)
        let radius = self.radius <= 0 ? maxRadius : self.radius
        var textRadius = radius
        switch verticalTextAlignment {
        case .inside:
            textRadius = textRadius - stringSize.height;
        case .center:
            textRadius = textRadius - stringSize.height/2;
        case .outside:
            break
        }
        let circumference = 2 * textRadius * .pi;
        let anglePerPixel = .pi * 2 / circumference * characterSpacing;
        
        let startAngle: CGFloat
        switch textAlignment {
        case .right:
            startAngle = self.baseAngle - (stringSize.width * anglePerPixel);
        case .left:
            startAngle = self.baseAngle;
        default:
            startAngle = self.baseAngle - (stringSize.width * anglePerPixel/2);
        }
        
        var characterPosition: CGFloat = 0;
        
        for character in text {
            let string = NSString(string: String(character))
            let stringSize = string.size(withAttributes: textAttributes)
            let kerning: CGFloat = 0.0
            characterPosition += (stringSize.width / 2) - kerning
            let angle = characterPosition * anglePerPixel + startAngle;
            let characterPoint = CGPoint(
                x: textRadius * cos(angle) + circleCenter.x,
                y: textRadius * sin(angle) + circleCenter.y
            )
            let stringPoint = CGPoint(
                x: characterPoint.x - stringSize.width/2,
                y: characterPoint.y - stringSize.height
            )
            
            context.saveGState()
            context.translateBy(x: characterPoint.x, y: characterPoint.y)
            let transform = CGAffineTransform(rotationAngle: angle + .pi / 2)
            context.concatenate(transform)
            context.translateBy(x: -characterPoint.x, y: -characterPoint.y)

            //Draw the character
            string.draw(at: stringPoint, withAttributes: textAttributes)
            context.restoreGState()
            characterPosition += stringSize.width / 2;
        }
        
    }
}

extension CXRTextArcView {
    private func setup() {
        backgroundColor = .clear
    }
    
    private func maximumRadius(size: CGSize, vertical alignment: VerticalAlignment) -> CGFloat {
        let width = bounds.size.width
        let height = bounds.size.height
        var radius = (width <= height) ? width / 2: height / 2;
        switch alignment {
        case .outside:  radius = radius - size.height
        case .center:   radius = radius - size.height/2;
        default:        break
        }
        return radius
    }
    
    private func kerning(current character1: NSString, previous character2: NSString) {
        
    }
}

extension CXRTextArcView {
    
    enum VerticalAlignment {
        case outside
        case center
        case inside
    }
}
