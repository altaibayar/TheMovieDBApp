//
//  InMemoryImageCache.swift
//  TheMovieDB
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//

import Foundation
import UIKit

class InMemoryImageCache {

    var cache = [String: UIImage]();

    subscript(name: String) -> UIImage? {
        get {
            return cache[name];
        }
        set(val) {
            cache[name] = val;
        }
    }

}

