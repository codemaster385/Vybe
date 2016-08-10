//
//  DHCollectionTableViewCell.swift
//  DHCollectionTableView
//

//  Copyright (c) 2016 Param. All rights reserved.
//

import UIKit

class DHIndexedCollectionView: UICollectionView,UIGestureRecognizerDelegate {
  
    
  var indexPath: NSIndexPath!
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    
    super.init(frame: frame, collectionViewLayout: layout)
    self.pagingEnabled=true
    self.scrollEnabled=false
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(DHIndexedCollectionView.handleTap(_:)))
    tap.delegate = self
    self.addGestureRecognizer(tap)
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
       func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        print("tap receiver")
        
        
        //
        
        let  visibleArry       = self.indexPathsForVisibleItems();
        let indexpathVisible = visibleArry[0] ;
        
        
        let indexPath = NSIndexPath(forRow:indexpathVisible.row+1, inSection:0)
        
       self.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
        
        
        
        
        /*
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
        
        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
        
        
        if numberOfRows > 0 {
        let indexPath = NSIndexPath(forRow: indexpath.row, inSection:0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        }
        
        })*/
    }

}

let collectionViewCellIdentifier: NSString = "CollectionViewCell"
class DHCollectionTableViewCell: UITableViewCell {
  
  var collectionView: DHIndexedCollectionView!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    layout.minimumLineSpacing = 0
    layout.itemSize = CGSizeMake(0, 0)
    layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    self.collectionView = DHIndexedCollectionView(frame: CGRectZero, collectionViewLayout: layout)
    self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier as String)
    self.collectionView.backgroundColor = UIColor.lightGrayColor()
    self.collectionView.showsHorizontalScrollIndicator = false
    self.contentView.addSubview(self.collectionView)
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
    
    
    
  }
  
    
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let frame = self.contentView.bounds
    self.collectionView.frame = CGRectMake(0,0, frame.size.width, frame.size.height)
  }
  
  func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: protocol<UICollectionViewDelegate,UICollectionViewDataSource>, index: NSInteger) {
    self.collectionView.dataSource = delegate
    self.collectionView.delegate = delegate
    self.collectionView.tag = index
    self.collectionView.reloadData()
  }
  
  func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: protocol<UICollectionViewDelegate,UICollectionViewDataSource>, indexPath: NSIndexPath) {
    self.collectionView.dataSource = delegate
    self.collectionView.delegate = delegate
    self.collectionView.indexPath = indexPath
    self.collectionView.tag = indexPath.section
    self.collectionView.reloadData()
  }
}
