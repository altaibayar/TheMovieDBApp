//
//  MoviesDataSource.swift
//  TheMovieDB
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//

import Foundation
import UIKit

protocol MoviesDataSource {
    func fetchMovies(page: Int, completion: @escaping ([MovieModel], NSError?) -> ());
    func fetchMovieDetail(movieId: Int, completion: @escaping (MovieModel?, NSError?) -> ());
    func fetchMoviePoster(moviePosterPath: String, tag: Int, completion: @escaping (Int, UIImage?, NSError?) -> ());
}

