//
//  MockMoviesDataSource.swift
//  TheMovieDB
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//

import Foundation
import UIKit

class MockMoviesDataSource: MoviesDataSource {
    func fetchMovies(page: Int, completion: @escaping ([MovieModel], NSError?) -> ()) {

        DispatchQueue.global(qos: .background).async {
            var result = [MovieModel]();

            for i in 0 ... 20 {
                let model = MovieModel();
                model.id = 550;
                model.title = "\(page)_\(i) One Direction: This Is Us";
                model.popularity = 1.2;
                model.imageUrl = "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg";

                result.append(model);
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(result, nil);
            }
        }
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (MovieModel?, NSError?) -> ()) {

        DispatchQueue.global(qos: .background).async {
            let model = MovieModel();
            model.id = movieId;
            model.imageUrl = "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg";
            model.title = "Fight Club";
            model.popularity = 0.5;
            model.synopsis = "A ticking-time-bomb insomniac and a slippery soap salesman" +
                " channel primal male aggression into a shocking new form of therapy." +
                " Their concept catches on, with underground \"fight clubs\" forming" +
                " in every town, until an eccentric gets in the way and ignites an" +
            " out-of-control spiral toward oblivion.";
            model.genres = [ "Drama", "Fight" ];
            model.language = "en";
            model.duration = 139;

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(model, nil);
            }
        }
    }

    func fetchMoviePoster(moviePosterPath: String, tag: Int, completion: @escaping (Int, UIImage?, NSError?) -> ()) {

        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(tag, UIImage(named: "no_image"), nil);
            }
        }
    }
}

