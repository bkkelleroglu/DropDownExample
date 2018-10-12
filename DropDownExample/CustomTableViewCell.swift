//
//  CustomTableViewCell.swift
//  DropDownExample
//
//  Created by Kai-Marcel Teuber on 12.10.18.
//  Copyright © 2018 Burak Kelleroğlu. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var customLogoImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
