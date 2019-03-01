//
//  FirstViewController.swift
//  Imagemaker
//
//  Created by Ruslan Alikhamov on 26.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import UIKit
import Combiner

class FirstViewController: UIViewController, CombinerSupport {
    
    var combiner: Combiner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.combiner?.currentImages { images in
//            print(error)
        }
    }


}

