//
//  StringProtocol.swift
//  
//
//  Created by Leonardo Savio Dabus on 12/05/24.
//

import struct Foundation.Data

public extension StringProtocol {

    var data: Data { .init(utf8) }
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }

    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { startIndex in
            guard startIndex < self.endIndex else { return nil }
            let endIndex = self.index(
                startIndex,
                offsetBy: 2,
                limitedBy: self.endIndex
            ) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}
