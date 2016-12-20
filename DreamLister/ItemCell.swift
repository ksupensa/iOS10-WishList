//
//  ItemCell.swift
//  DreamLister
//
//  Created by Spencer Forrest on 16/12/2016.
//  Copyright © 2016 Spencer Forrest. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var Thumb: UIImageView!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Details: UILabel!
    
    func configureCell(item: Item){
        Title.text = item.title
        Price.text = "$\(item.price)"
        Details.text = item.details
        Thumb.image = item.toImage?.image as? UIImage
    }
}
