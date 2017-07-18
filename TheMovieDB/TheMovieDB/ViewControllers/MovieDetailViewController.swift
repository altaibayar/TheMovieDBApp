//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var synopsesLabel: UILabel!
    @IBOutlet weak var bookMovieButton: UIButton!

    var currentMovie: MovieModel?;
    var dataSource: MoviesDataSource?;

    override func viewDidLoad() {
        super.viewDidLoad();

        self.view.backgroundColor = UIColor.backgroundColor;

        self.bookMovieButton.backgroundColor = UIColor.clear;
        self.bookMovieButton.layer.borderColor = UIColor.tintColor.cgColor;
        self.bookMovieButton.layer.borderWidth = 1.0;
        self.bookMovieButton.layer.masksToBounds = true;
        self.bookMovieButton.setTitleColor(UIColor.tintColor, for: .normal);

        if let movie = self.currentMovie {
            showMovie(movie: movie);
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.bookMovieButton.layer.cornerRadius = self.bookMovieButton.frame.height / 2;
    }

    fileprivate func showMovie(movie: MovieModel) {
        self.title = movie.title;

        if let path = movie.imageUrl {
            dataSource?.fetchMoviePoster(moviePosterPath: path, tag: 0, completion: { [weak self] (tag, img, error) in
                if let img = img {
                    self?.posterImageView.image = img;
                }
            })
        }

        self.genresLabel.text = String(format: "Genres: %@", movie.genresText());
        self.languageLabel.text = String(format: "Language: %@", movie.language ?? "");
        self.durationLabel.text = String(format: "Duration: %@", TimeFormatUtil.formatDuration(minutes: movie.duration ?? 0));
        self.synopsesLabel.text = movie.synopsis ?? "";
    }
}

//mark: - MovieModel

fileprivate extension MovieModel {
    func genresText() -> String {
        if let genres = self.genres {
            return genres.joined(separator: ", ");
        }

        return "";
    }
}

