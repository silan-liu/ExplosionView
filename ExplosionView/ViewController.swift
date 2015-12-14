//
//  ViewController.swift
//  ExplosionView
//
//  Created by liusilan on 15/12/9.
//  Copyright © 2015年 YY Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var codeImageView: UIImageView!

    @IBOutlet weak var chromeImageView: UIImageView!
    @IBOutlet weak var consoleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let chromeLayer = ExplosionLayer.createLayer(self.view.layer, chromeImageView, ExplosionAnimationType.UpAnimation)

        chromeLayer.explode()

        let consoleLayer = ExplosionLayer.createLayer(self.view.layer, consoleImageView, ExplosionAnimationType.FallAnimation)

        consoleLayer.explode()

        let codeLayer = ExplosionLayer.createLayer(self.view.layer, codeImageView, ExplosionAnimationType.FallAnimation)

        codeLayer.explode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

