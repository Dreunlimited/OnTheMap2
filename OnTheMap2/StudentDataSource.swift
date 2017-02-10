//
//  StudentDataSource.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 2/9/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import Foundation

class StudentDataSource {
    var studentData = [StudentLocation]()
    static let sharedInstance = StudentDataSource()
    private init() {}
}
