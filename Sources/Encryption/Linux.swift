//
//  File.swift
//  
//
//  Created by lsd on 10/05/24.
//

#if os(Linux) && canImport(Cypto)
import Foundation
import protocol Foundation.ContiguousBytes
import protocol Foundation.DataProtocol
import struct Foundation.Data

import Cypto
import struct Crypto.SymmetricKey
import struct Crypto.SHA256Digest
import struct Crypto.SHA384Digest
import struct Crypto.SHA512Digest
import enum Crypto.AES
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
#endif

#if os(Linux) && canImport(NIOCore)
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
