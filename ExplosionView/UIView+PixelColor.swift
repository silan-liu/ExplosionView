//
//  UIView+PixelColor.swift
//  ExplosionView
//
//  Created by liusilan on 15/12/9.
//  Copyright © 2015年 YY Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    public func colorOfPoint(point:CGPoint) -> UIColor
    {
        var pixel:[CUnsignedChar] = [0,0,0,0]

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)

        let context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, colorSpace, bitmapInfo.rawValue)

        CGContextTranslateCTM(context, -point.x, -point.y)

        self.layer.renderInContext(context!)

        let red: CGFloat = CGFloat(pixel[0]) / 255.0
        let green: CGFloat = CGFloat(pixel[1]) / 255.0
        let blue: CGFloat = CGFloat(pixel[2]) / 255.0
        let alpha: CGFloat = CGFloat(pixel[3]) / 255.0

        return UIColor(red:red, green: green, blue:blue, alpha:alpha)
    }
}