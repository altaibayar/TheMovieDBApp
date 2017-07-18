//
//  RESTService.swift
//  TheMovieDB
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//

import Foundation

class RESTService {

    let session: URLSession;

    init() {
        self.session = URLSession(configuration: .default);
    }

    func GET(url: String, completion: @escaping (Data?, Error?) -> ()) {

        guard let url = URL(string: url) else {
            completion(nil, NSError());
            return;
        }

        self.session.dataTask(with: url) { (data, response, error) in
            completion(data, error);
            }.resume();
    }
}

