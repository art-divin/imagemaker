//
//  SecondViewController.swift
//  Imagemaker
//
//  Created by Ruslan Alikhamov on 26.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import UIKit
import Combiner
import Container

class SecondViewController: UIViewController, CombinerSupport {
    
    var combiner: Combiner?
    var images : [ImagePure]?
    
    @IBOutlet var collectionView : UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.combiner?.currentImages { images in
            self.images = images
            self.collectionView?.reloadData()
        }
    }


}

extension SecondViewController : UICollectionViewDelegate {
    
    
    
}

extension SecondViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondViewControllerCollectionView"
            , for: indexPath) as! SecondViewControllerCollectionCell
        
        if let image = self.images?[indexPath.row], let data = image.data {
            // NSData needs to be decompressed into bitmap in-memory before
            // it is assigned to the imageView (and rendered) due to the fact
            // that if UIImageView gets a compressed image data then it
            // decodes it. And it does it on the main thread, of course.
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
    
}

