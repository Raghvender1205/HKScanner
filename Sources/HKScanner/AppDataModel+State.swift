//
//  AppDataModel+State.swift
//
//
//  Created by Raghvender on 12/12/23.
//

import Foundation

public extension AppDataModel {
    public enum ModelState: String, CustomStringConvertible {
        var description: String { rawValue }

        case notSet
        case ready
        case capturing
        case prepareToReconstruct
        case reconstructing
        case viewing
        case completed
        case restart
        case failed
    }
}
