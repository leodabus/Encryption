// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  Encryption.swift
//
//
//  Created by Leonardo Savio Dabus on 10/05/24.
//

#if canImport(Vapor)
import Foundation
import protocol Foundation.ContiguousBytes
import protocol Foundation.DataProtocol
import struct Foundation.Data
import NIOCore
import struct NIOCore.ByteBuffer
import Vapor
import struct Vapor.SymmetricKey
import struct Vapor.SHA256Digest
import struct Vapor.SHA384Digest
import struct Vapor.SHA512Digest
import enum Vapor.AES
#elseif canImport(CriptoKit)
import Foundation
import protocol Foundation.ContiguousBytes
import protocol Foundation.DataProtocol
import struct Foundation.Data
import CriptoKit
import struct CriptoKit.SymmetricKey
import struct CriptoKit.SHA256Digest
import struct CriptoKit.SHA384Digest
import struct CriptoKit.SHA512Digest
import enum CriptoKit.AES
#endif

#if canImport(CriptoKit) || canImport(Vapor)
public extension StringProtocol {

    var sha256hexa: String { data.sha256digest.hexa }
    var sha384hexa: String { data.sha384digest.hexa }
    var sha512hexa: String { data.sha512digest.hexa }

    func sealed<D: ContiguousBytes>(
        using key: D,
        nonce: AES.GCM.Nonce? = nil
    ) throws -> AES.GCM.SealedBox {
        try AES.GCM.seal(data, using: key.symmetricKey, nonce: nonce)
    }

    func encrypted<D: ContiguousBytes>(using key: D) throws -> Data? {
        try sealed(using: key).combined
    }
}

public extension DataProtocol {
    var sha256digest: SHA256Digest { SHA256.hash(data: self) }
    var sha384digest: SHA384Digest { SHA384.hash(data: self) }
    var sha512digest: SHA512Digest { SHA512.hash(data: self) }
    func sealedBox() throws -> AES.GCM.SealedBox { try .init(combined: self) }
    func decrypt<D: ContiguousBytes>(using key: D) throws -> Data? {
        try AES.GCM.open(
            sealedBox(),
            using: key.symmetricKey
        )
    }
}

public extension ContiguousBytes {
    var symmetricKey: SymmetricKey { .init(data: self) }
}
#endif


#if canImport(NIOCore)
import Foundation
import protocol Foundation.ContiguousBytes
import protocol Foundation.DataProtocol
import struct Foundation.Data
import NIOCore
import struct NIOCore.ByteBuffer
public extension ByteBuffer {
    var data: Data {
        var bytes = self
        return Data(bytes.readBytes(length: bytes.readableBytes)!)
    }
}
#endif
