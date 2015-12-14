//
//  ExplosionHelper.swift
//  ExplosionView
//
//  Created by liusilan on 15/12/10.
//  Copyright © 2015年 YY Inc. All rights reserved.
//

import Foundation
import UIKit

enum ExplosionAnimationType: Int {
    case FallAnimation
    case UpAnimation
    // ...you can add your animation
}

class ExplosionHelper {

    //MARK:cacalute
    // 计算粒子位置
    class func caculatePositions(targetViewSize: CGSize) -> [String: CGRect] {
        let pointWidth: CGFloat = 2
        let pointHeight = pointWidth
        let margin: CGFloat = 1

        let targetViewWidth = targetViewSize.width
        let targetViewHeight = targetViewSize.height

        // 计算水平，竖直方向粒子个数
        let hCount: Int = Int(targetViewWidth) / Int(pointWidth + margin)
        let VCount: Int = Int(targetViewHeight) / Int(pointHeight + margin)

        var frame: CGRect = CGRectZero
        var rectDict: [String: CGRect] = [:]

        for i in 0..<hCount {
            for j in 0..<VCount {

                frame = CGRectMake(CGFloat(pointWidth + margin) * CGFloat(i),
                    CGFloat(pointHeight + margin) * CGFloat(j),
                    pointWidth, pointHeight)

                // "i-j":frame
                let key = String(format: "%d-%d", i, j)
                rectDict[key] = frame
            }
        }

        return rectDict
    }

    // 计算每个点的颜色值
    class func caculatePointColor(dict: [String: CGRect], _ targetView: UIView) -> [String: UIColor] {

        var colorDict: [String: UIColor] = [:]
        for (key, rect) in dict {
            let color = targetView.colorOfPoint(rect.origin)
            colorDict[key] = color
        }

        return colorDict
    }

    // 计算水平方向粒子数
    class func caculatePointHCount(targetViewWidth: CGFloat) -> Int {

        let pointWidth: CGFloat = 2
        let margin: CGFloat = 1

        // 计算水平，水平方向粒子个数
        let hCount: Int = Int(targetViewWidth) / Int(pointWidth + margin)

        return hCount
    }

    // 计算竖直方向粒子数
    class func caculatePointVCount(targetViewHeight: CGFloat) -> Int {

        let pointHeight: CGFloat = 2
        let margin: CGFloat = 1

        // 计算水平，竖直方向粒子个数
        let hCount: Int = Int(targetViewHeight) / Int(pointHeight + margin)

        return hCount
    }


    //MARK:create layer
    /**
     创建所有粒子图层

     - parameter containerLayer: 父layer
     - parameter targetView:     要发生爆炸效果view
     - parameter animationType:  动画类型
     */
    class func createExplosionPoints(containerLayer: ExplosionLayer, targetView: UIView, animationType: ExplosionAnimationType) {

        let hCount = self.caculatePointHCount(containerLayer.targetSize.width)
        let vCount = self.caculatePointVCount(containerLayer.targetSize.height)

        for i in 0..<hCount {
            for j in 0..<vCount {
                let key = String(format: "%d-%d", i, j)
                if let rect = containerLayer.frameDict[key], color = containerLayer.colorDict[key] {

                    let layer = createExplosionPointLayer(rect, bgColor: color, targetViewSize: containerLayer.targetSize)

                    // animation
                    layer.explosionAnimation = self.createAnimationWithType(animationType, position: layer.position, targetViewSize: containerLayer.targetSize)

                    containerLayer.addSublayer(layer)
                    
                    layer.beginAnimation()
                }
            }
        }
    }

    // 创建粒子，默认下落效果
    class func createExplosionPoints(containerLayer: ExplosionLayer, targetView: UIView) {

        self.createExplosionPoints(containerLayer, targetView: targetView, animationType: .FallAnimation)
    }

    /**
     创建粒子

     - parameter frame
     - parameter bgColor

     - returns: ExplosionPointLayer
     */
    class func createExplosionPointLayer(frame: CGRect, bgColor: UIColor, targetViewSize: CGSize) -> ExplosionPointLayer {

        let layer = ExplosionPointLayer()

        layer.fillColor = bgColor.CGColor

        let path: UIBezierPath = UIBezierPath(roundedRect: frame, cornerRadius: frame.size.width / 2)
        layer.path = path.CGPath

        let fallAnimation = FallAnimation(position: layer.position, targetViewSize: targetViewSize)

        layer.explosionAnimation = fallAnimation

        return layer
    }

    /**
     创建动画效果

     - parameter type:           动画类型
     - parameter position:       起点position
     - parameter targetViewSize

     - returns: 返回动画
     */
    private class func createAnimationWithType(type: ExplosionAnimationType,
        position: CGPoint, targetViewSize: CGSize) -> ExplosionAnimationProtocol {
        switch type {
        case .FallAnimation:
            return FallAnimation(position: position, targetViewSize: CGSizeMake(targetViewSize.width, targetViewSize.height))

        case .UpAnimation:
            return UpAnimation(position: position, targetViewSize: CGSizeMake(targetViewSize.width, targetViewSize.height))

            // add your animation here
        }
    }
}