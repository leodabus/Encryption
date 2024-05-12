//
//  File.swift
//  
//
//  Created by lsd on 10/05/24.
//

#if os(Linux)
import Crypto
import struct Crypto.SymmetricKey
import NIOCore
import struct NIOCore.ByteBuffer
import Foundation
import protocol Foundation.ContiguousBytes
import protocol Foundation.DataProtocol
import struct Foundation.Data

public extension StringProtocol {

    public var sha256hexa: String { data.sha256digest.hexa }
    public var sha384hexa: String { data.sha384digest.hexa }
    public var sha512hexa: String { data.sha512digest.hexa }

    public func sealed<D: ContiguousBytes>(
        using key: D,
        nonce: AES.GCM.Nonce? = nil
    ) throws -> AES.GCM.SealedBox {
        try AES.GCM.seal(data, using: key.symmetricKey, nonce: nonce)
    }

    public func encrypted<D: ContiguousBytes>(using key: D) throws -> Data? {
        try sealed(using: key).combined
    }
}

public extension DataProtocol {

    public var sha256digest: SHA256Digest { SHA256.hash(data: self) }
    public var sha384digest: SHA384Digest { SHA384.hash(data: self) }
    public var sha512digest: SHA512Digest { SHA512.hash(data: self) }

    public func sealedBox() throws -> AES.GCM.SealedBox { try .init(combined: self) }

    public func decrypt<D: ContiguousBytes>(using key: D) throws -> Data? {
        try AES.GCM.open(
            sealedBox(),
            using: key.symmetricKey
        )
    }
}

public extension ContiguousBytes {
    public var symmetricKey: SymmetricKey { .init(data: self) }
}

public extension ByteBuffer {
    var data: Data {
        readBytes(length: readableBytes)!
    }
}

#endif
