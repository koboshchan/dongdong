public enum CompatibilityStatus: Equatable, Sendable {
    case supported(developerBeta: Int)
    case unsupportedVersion
    case unsupportedBuild
    case buildUnavailable

    public var isSupported: Bool {
        if case .supported = self { return true }
        return false
    }

    public var title: String { isSupported ? "Supported" : "Not supported" }

    public var explanation: String {
        switch self {
        case .supported(let beta):
            "Matches the iOS 27.0 developer beta \(beta) allowlist. This is a version check only."
        case .unsupportedVersion:
            "Only iOS 27.0.0 is allowlisted. Other versions are not supported."
        case .unsupportedBuild:
            "This build is not one of the four allowlisted iOS 27.0 developer beta builds."
        case .buildUnavailable:
            "The system build could not be read. Compatibility cannot be confirmed."
        }
    }
}
