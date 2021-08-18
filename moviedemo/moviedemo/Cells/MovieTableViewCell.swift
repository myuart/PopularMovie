//
//  MovieTableViewCell.swift
//  moviedemo
//
//  Created by Maria Yu on 7/29/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
