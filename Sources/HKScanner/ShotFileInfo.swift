//
//  ShotFileInfo.swift
//
//
//  Created by Raghvender on 12/12/23.
//

import Combine
import Foundation
import SwiftUI
import UIKit

struct ShotFileInfo {
    let fileURL: URL
    let id: UInt32

    init?(url: URL) {
        fileURL = url
        guard let shotID = CaptureFolderManager.parseShotId(url: url) else {
            return nil
        }

        id = shotID
    }
}

extension ShotFileInfo: Identifiable { }
