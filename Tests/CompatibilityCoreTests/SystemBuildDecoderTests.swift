import XCTest
@testable import CompatibilityCore

final class SystemBuildDecoderTests: XCTestCase {
    func testDecodesTerminatedASCII() {
        XCTAssertEqual(SystemBuildDecoder.decode(Array("24A5355q".utf8) + [0]), "24A5355q")
    }

    func testRejectsTruncatedAndEmptyStrings() {
        XCTAssertNil(SystemBuildDecoder.decode(Array("24A5355q".utf8)))
        XCTAssertNil(SystemBuildDecoder.decode([]))
        XCTAssertNil(SystemBuildDecoder.decode([0]))
    }

    func testRejectsEmbeddedNullWhitespaceAndNonASCII() {
        for bytes in [
            Array("24A5355q ".utf8) + [0],
            Array("24A5355q\n".utf8) + [0],
            Array("24A5355q".utf8) + [0, 0],
            [UInt8(255), 0],
            Array("24A5355qé".utf8) + [0]
        ] {
            XCTAssertNil(SystemBuildDecoder.decode(bytes))
        }
    }

    func testUnknownWellFormedBuildStillFailsPolicy() {
        let build = SystemBuildDecoder.decode(Array("24A9999z".utf8) + [0])
        XCTAssertEqual(build, "24A9999z")
        XCTAssertEqual(
            CompatibilityPolicy.evaluate(version: .init(major: 27, minor: 0, patch: 0), build: build),
            .unsupportedBuild
        )
    }
}
