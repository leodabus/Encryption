//
//  File.swift
//  
//
//  Created by lsd on 10/05/24.
//

#if os(macOS)
import Foundation
import protocol Foundation.ContiguousBytes
import struct Foundation.Data
import CryptoKit

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
