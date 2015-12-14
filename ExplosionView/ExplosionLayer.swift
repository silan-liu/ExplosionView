//
//  ExplosionLayer.swift
//  ExplosionView
//
//  Created by liusilan on 15/12/10.
//  Copyright © 2015年 YY Inc. All rights reserved.
//

import Foundation
import UIKit

class ExplosionLayer: CALayer {

    private weak var targetView: UIView?
    private weak var parentLayer: CALayer?
    private var semaphore: dispatch_semaphore_t?

    var targetSize: CGSize { if let targetView = self.targetView {
            return targetView.frame.size
        }
        return CGSizeMake(0, 0)
    }

    var frameDict: [String: CGRect] = [:]
    var colorDict: [String: UIColor] = [:]

    var animationType: ExplosionAnimationType = ExplosionAnimationType.FallAnimation

    /**
     创建爆炸效果layer

     - parameter superLayer
     - parameter targetView: 发生爆炸效果的view
     */
    class func createLayer(superLayer: CALayer, _ targetView: UIView, _ animationType: ExplosionAnimationType) -> ExplosionLayer {

        let layer = ExplosionLayer()

        layer.frame = targetView.frame

        layer.backgroundColor = UIColor.whiteColor().CGColor

        layer.targetView = targetView

        layer.parentLayer = superLayer
        layer.animationType = animationType

        return layer
    }

    // 爆炸
    func explode() {
        self.shake()
    }

    // 震动效果
    private func shake() {

        self.createSemaphore()

        // 计算位置，色值
        self.caculate()

        let shakeAnimation = CAKeyframeAnimation(keyPath: "position")

        shakeAnimation.values = [NSValue.init(CGPoint: self.position), NSValue.init(CGPoint: CGPointMake(self.position.x, self.position.y + 1)), NSValue.init(CGPoint: CGPointMake(self.position.x + 1, self.position.y - 1)), NSValue.init(CGPoint: CGPointMake(self.position.x - 1, self.position.y + 1))]

        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 15
        shakeAnimation.delegate = self
        shakeAnimation.removedOnCompletion = true

        self.targetView?.layer.addAnimation(shakeAnimation, forKey: "shake")
    }

    // 创建信号量
    private func createSemaphore() {
        self.semaphore = dispatch_semaphore_create(0)
    }

    // 后台计算点和颜色值
    private func caculate() {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in

            let startTime = CFAbsoluteTimeGetCurrent()

            self.frameDict = ExplosionHelper.caculatePositions(self.targetSize)

            if let targetView = self.targetView {
                self.colorDict = ExplosionHelper.caculatePointColor(self.frameDict,
                    targetView)
            }

            let endTime = CFAbsoluteTimeGetCurrent()
            print("waste time: \(endTime - startTime)")

            dispatch_semaphore_signal(self.semaphore!)
        }
    }

    //MARK:animation delegate
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {

        // wait for caculate
        dispatch_semaphore_wait(self.semaphore!, DISPATCH_TIME_FOREVER)

        print("shake animation stop")

        // begin explode
        if let targetView = self.targetView {
            self.parentLayer?.addSublayer(self)
            ExplosionHelper.createExplosionPoints(self, targetView: targetView, animationType: self.animationType)

            self.targetView?.hidden = true
        }
    }
}