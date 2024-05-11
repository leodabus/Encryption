// The Swift Programming Language
// https://docs.swift.org/swift-book

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

public extension Sequence where Element == UInt8 {

    var string: String? { .init(bytes: self, encoding: .utf8) }
    var hexa: String { map { String(format: "%02hhx", $0) }.joined() }
}
