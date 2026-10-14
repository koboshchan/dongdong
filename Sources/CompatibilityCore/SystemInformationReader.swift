import Foundation
#if canImport(Darwin)
import Darwin
#endif

public enum SystemInformationReader {
    public static func snapshot() -> SystemSnapshot {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return SystemSnapshot(
            version: SystemVersion(
                major: version.majorVersion,
                minor: version.minorVersion,
                patch: version.patchVersion
            ),
            build: readBuild()
        )
    }

    private static func readBuild() -> String? {
        #if canImport(Darwin)
        // Both calls are read-only: newp is nil and newlen is zero.
        var length = 0
        guard sysctlbyname("kern.osversion", nil, &length, nil, 0) == 0,
              (2...256).contains(length) else { return nil }
        var bytes = [UInt8](repeating: 0, count: length)
        let capacity = bytes.count
        let result = bytes.withUnsafeMutableBytes { buffer in
            sysctlbyname("kern.osversion", buffer.baseAddress, &length, nil, 0)
        }
        guard result == 0, (2...capacity).contains(length) else { return nil }
        return SystemBuildDecoder.decode(Array(bytes.prefix(length)))
        #else
        return nil
        #endif
    }
}
