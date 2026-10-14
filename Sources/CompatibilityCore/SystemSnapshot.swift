public struct SystemSnapshot: Equatable, Sendable {
    public let version: SystemVersion
    public let build: String?

    public init(version: SystemVersion, build: String?) {
        self.version = version
        self.build = build
    }

    public var status: CompatibilityStatus {
        CompatibilityPolicy.evaluate(version: version, build: build)
    }
}
