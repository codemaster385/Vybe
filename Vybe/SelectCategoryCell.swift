//
//  SelectCategoryCell.swift
//  Vybe
//
//  Created by paramvir singh on 13/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit

class SelectCategoryCell: UICollectionViewCell
{
    
    

    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet weak var selectionImgView: UIImageView!
    
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        
        
        
        
    }
    
    override func awakeFromNib() {
    super.awakeFromNib()
        
       // self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        self.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = true;
        
     //   baseView.layer.masksToBounds = true;
      //  baseView.clipsToBounds = true
    }
}
