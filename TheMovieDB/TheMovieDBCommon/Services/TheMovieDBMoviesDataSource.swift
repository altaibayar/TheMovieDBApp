//
//  TheMovieDBMoviesDataSource.swift
//  TheMovieDB
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//

import Foundation
import UIKit

class TheMovieDBMoviesDataSource: MoviesDataSource {

    let API: String = "YOUR_KEY_HERE";
    let rest = RESTService();
    let imageCache = InMemoryImageCache();

    func fetchMovies(page: Int, completion: @escaping ([MovieModel], NSError?) -> ()) {
        //https://api.themoviedb.org/3/discover/movie?api_key={API}&language=en-US&sort_by=release_date.desc&page={PAGE}
        let url = String(format: "https://api.themoviedb.org/3/discover/movie?api_key=%@&sort_by=release_date.desc&page=%d",
                         self.API, page);

        rest.GET(url: url) { (data, error) in

            if error != nil {
                DispatchQueue.main.async {
                    completion([], NSError(domain: "network", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Some Error" ]));
                }
                return;
            }

            if let data = data,
                let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let movies = dict?["results"] as? [[String: Any]] {

                var result = [MovieModel]();
                for movie in movies {
                    result.append(MovieModel(dict: movie));
                }

                DispatchQueue.main.async {
                    completion(result, nil);
                }
                return;
            }

            DispatchQueue.main.async {
                completion([], nil);
            }
        };
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (MovieModel?, NSError?) -> ()) {
        //https://api.themoviedb.org/3/movie/{KEY}?api_key={API}&language=en-US
        let url = String(format: "https://api.themoviedb.org/3/movie/%d?api_key=%@&language=en-US", movieId, self.API);
        rest.GET(url: url) { (data, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "network", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Some Error" ]));
                }
                return;
            }

            if let data = data,
                let obj = try? JSONSerialization.jsonObject(with: data),
                let dict = obj as? [String: Any] {

                let movie = MovieModel(dict: dict);
                DispatchQueue.main.async { completion(movie, nil); }
            }
        }
    }

    func fetchMoviePoster(moviePosterPath: String, tag: Int, completion: @escaping (Int, UIImage?, NSError?) -> ()) {

        //https://image.tmdb.org/t/p/w500/kqjL17yufvn9OVLyXYpvtyrFfak.jpg

        if let img = self.imageCache[moviePosterPath] {
            DispatchQueue.main.async { completion(tag, img, nil); }
        }

        let url = String(format: "https://image.tmdb.org/t/p/w500%@", moviePosterPath);
        rest.GET(url: url) { (data, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(tag, UIImage(named: "no_image"), NSError(domain: "network", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Some Error" ]));
                }
                return;
            }

            if let data = data, let img = UIImage(data: data) {

                self.imageCache[moviePosterPath] = img;
                DispatchQueue.main.async { completion(tag, img, nil); }
            } else {
                DispatchQueue.main.async { completion(tag, UIImage(named: "no_image"), nil); }
            }
        }
    }
}

