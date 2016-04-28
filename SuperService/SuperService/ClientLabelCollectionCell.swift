//
//  ClientLabelCollectionCell.swift
//  SuperService
//
//  Created by AlexBang on 16/4/28.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class ClientLabelCollectionCell: UICollectionViewCell {
    
  @IBOutlet weak var tagLabel: UILabel!
  
  func configCell(tag:Tag) {
    tagLabel.text = tag.tagname
  }
}
