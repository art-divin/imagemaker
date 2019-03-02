//
//  FirstViewController.swift
//  Imagemaker
//
//  Created by Ruslan Alikhamov on 26.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import UIKit
import Combiner
import CoreLocation

class FirstViewController: UIViewController, CombinerSupport {
    
    @IBOutlet var imageView : UIImageView?
    var combiner: Combiner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.combiner?.lastImage { image in
            if let data = image?.data {
                self.imageView?.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func start(_ sender: Any?) {
        self.combiner?.start()
    }
    
    @IBAction func stop(_ sender: Any?) {
        self.combiner?.stop()
    }
    
}

