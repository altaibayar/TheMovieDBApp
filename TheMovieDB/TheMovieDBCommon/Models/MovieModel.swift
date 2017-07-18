//
//  MovieModel.swift
//  TheMovieDB
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//

import Foundation

class MovieModel {

    var id: Int?;
    var imageUrl: String?;
    var title: String?;
    var popularity: Double?;
    var synopsis: String?;
    var genres: [String]?
    var language: String?
    var duration: Int?

    convenience init(dict: [String: Any]) {
        self.init();

        self.id = dict["id"] as? Int;
        self.imageUrl = dict["poster_path"] as? String;
        self.title = dict["title"] as? String;
        self.popularity = dict["popularity"] as? Double;
        self.synopsis = dict["overview"] as? String;
        self.genres = getGenreNames(dict: dict["genres"] as? [[String: Any]]);
        self.language = dict["original_language"] as? String;
        self.duration = dict["runtime"] as? Int;
    }

    fileprivate func getGenreNames(dict: [[String: Any]]?) -> [String] {

        guard let dict = dict else {
            return [];
        }

        var result = [String]();
        for kvp in dict {
            if let name = kvp["name"] as? String {
                result.append(name);
            }
        }

        return result;
    }

}

