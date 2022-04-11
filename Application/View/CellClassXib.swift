//
//  CellClassXib.swift
//  CarJournal
//
//  Created by Cheremisin Andrey on 09.04.2022.
//

import UIKit

class CellClassXib: UITableViewCell {
    
    
    @IBOutlet weak var imageofWork: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelMilage: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
