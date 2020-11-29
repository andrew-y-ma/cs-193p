//
//  Array+Only.swift
//  Memorize
//
//  Created by Andrew Ma on 2020-11-28.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
