enum SystemBuildDecoder {
    /// Reject malformed or truncated C strings instead of normalizing into an allowlisted build.
    static func decode(_ bytes: [UInt8]) -> String? {
        guard bytes.last == 0 else { return nil }
        let contents = bytes.dropLast()
        guard !contents.isEmpty,
              contents.allSatisfy({ (48...57).contains($0) || (65...90).contains($0) || (97...122).contains($0) })
        else { return nil }
        return String(decoding: contents, as: UTF8.self)
    }
}
