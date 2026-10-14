import XCTest
@testable import CompatibilityCore

final class CompatibilityPolicyTests: XCTestCase {
    private let allowedVersion = SystemVersion(major: 27, minor: 0, patch: 0)
    private let builds = ["24A5355q", "24A5370h", "24A5380h", "24A5390f"]

    func testEachAllowlistedBuildMapsToItsDeveloperBeta() {
        for (index, build) in builds.enumerated() {
            let status = CompatibilityPolicy.evaluate(version: allowedVersion, build: build)
            XCTAssertEqual(status, .supported(developerBeta: index + 1))
            XCTAssertTrue(status.isSupported)
        }
    }

    func testEveryAllowedBuildRequiresExactVersion() {
        let versions = [
            SystemVersion(major: 26, minor: 0, patch: 0),
            SystemVersion(major: 27, minor: 0, patch: 1),
            SystemVersion(major: 27, minor: 1, patch: 0),
            SystemVersion(major: 27, minor: 2, patch: 0),
            SystemVersion(major: 28, minor: 0, patch: 0),
            SystemVersion(major: -27, minor: 0, patch: 0),
            SystemVersion(major: 27, minor: -1, patch: 0)
        ]
        for version in versions {
            for build in builds {
                let status = CompatibilityPolicy.evaluate(version: version, build: build)
                XCTAssertEqual(status, .unsupportedVersion)
                XCTAssertFalse(status.isSupported)
            }
        }
    }

    func testUnknownBuildsFailClosedWithoutNormalization() {
        let unknown = [
            "24A5400a", "24A5355Q", "24a5370h", "24A5380H", "24A5390F",
            "24A5355", "24A5355q ", " 24A5355q", "24A5370h\n",
            "24A5380h\0", "24A5390f-extra", "24A5355q/24A5370h", "unknown"
        ]
        for build in unknown {
            let status = CompatibilityPolicy.evaluate(version: allowedVersion, build: build)
            XCTAssertEqual(status, .unsupportedBuild, build)
            XCTAssertFalse(status.isSupported)
        }
    }

    func testUnreadableOrEmptyBuildFailsClosed() {
        for build in [nil, ""] as [String?] {
            let status = CompatibilityPolicy.evaluate(version: allowedVersion, build: build)
            XCTAssertEqual(status, .buildUnavailable)
            XCTAssertFalse(status.isSupported)
        }
    }

    func testVersionMismatchTakesPriorityOverUnreadableBuild() {
        XCTAssertEqual(
            CompatibilityPolicy.evaluate(version: .init(major: 27, minor: 2, patch: 0), build: nil),
            .unsupportedVersion
        )
    }

    func testSnapshotPreservesDetectedValuesAndUsesPolicy() {
        let snapshot = SystemSnapshot(version: allowedVersion, build: "24A5380h")
        XCTAssertEqual(snapshot.version.displayText, "27.0.0")
        XCTAssertEqual(snapshot.build, "24A5380h")
        XCTAssertEqual(snapshot.status, .supported(developerBeta: 3))
    }

    func testLinuxReaderNeverClaimsAnIOSBuild() {
        #if os(Linux)
        let snapshot = SystemInformationReader.snapshot()
        XCTAssertNil(snapshot.build)
        XCTAssertFalse(snapshot.status.isSupported)
        #endif
    }
}
