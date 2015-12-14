//
//  ExplosionPointLayer.swift
//  ExplosionView
//
//  Created by liusilan on 15/12/10.
//  Copyright © 2015年 YY Inc. All rights reserved.
//

import Foundation
import UIKit

class ExplosionPointLayer: CAShapeLayer {

    var explosionAnimation: ExplosionAnimationProtocol?

    func beginAnimation() {

        if let explosionAnimation = explosionAnimation {
            if let animation: CAAnimation = explosionAnimation.animation() {

                animation.delegate = self
                self.addAnimation(animation, forKey: "explosion")

                explosionAnimation.resetLayerProperty(self)
            }
        }
    }

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.removeFromSuperlayer()
    }
}