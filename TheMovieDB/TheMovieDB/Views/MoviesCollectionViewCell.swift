//
//  MoviesCollectionViewCell.swift
//  TheMovieDB
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//

import Foundation
import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var darkMaskView: UIView!

    var currentMovie: MovieModel?

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview);

        self.backgroundColor = UIColor.white;
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = true;
    }

    func bindData(movie: MovieModel) {
        self.currentMovie = movie;

        self.imageView.image = UIImage(named: "no_image");
        self.titleLabel.text = movie.title ?? "";

        if let p = movie.popularity {
            self.popularityLabel.text = String(format: "⭐️ %.02f", p);
        } else {
            self.popularityLabel.text = "";
        }
    }
}

