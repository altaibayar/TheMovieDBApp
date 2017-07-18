//
//  TimeFormatUtil.swift
//  TheMovieDB
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//

import Foundation

class TimeFormatUtil {
    class func formatDuration(minutes: Int) -> String {
        let hour = minutes / 60;
        let minute = minutes % 60;

        if hour == 0 {
            return String(format: "%02dmin", minute);
        } else {
            return String(format: "%02dh %02dmin", hour, minute);
        }
    }
}

