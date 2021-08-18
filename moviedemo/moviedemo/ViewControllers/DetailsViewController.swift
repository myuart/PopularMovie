//
//  DetailsViewController.swift
//  moviedemo
//
//  Created by Maria Yu on 8/17/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var overviewView: UITextView!
    
    var selectedMovie: SearchResult?
    var movieImagePathURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let movie = selectedMovie else { return }
        
        titleLabel.text = movie.title
        scoreLabel.text = "\(movie.popularity)"
        yearLabel.text = movie.release_date
        overviewView.text = movie.overview
        if let imagePath = movieImagePathURL {
            iconView.loadCachedThumbnail(urlSting: imagePath)
        }
    }
}
