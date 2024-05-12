//
//  File.swift
//  
//
//  Created by lsd on 12/05/24.
//

public extension Sequence where Element == UInt8 {

    var string: String? { .init(bytes: self, encoding: .utf8) }
    var hexa: String { map { String(format: "%02hhx", $0) }.joined() }
}
