//
//  BaseballStadiums.swift
//  Yanolja
//
//  Created by 박혜운 on 5/13/24.
//  Copyright © 2024 com.mc2.yanolja. All rights reserved.
//

import Foundation

enum BaseballStadiums {
  case jamsil
  
  var title: String {
    switch self {
    case .jamsil: return "잠실"
    }
  }
}
