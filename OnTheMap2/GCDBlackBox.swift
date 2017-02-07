//
//  GCDBlackBox.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/27/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import Foundation


func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
