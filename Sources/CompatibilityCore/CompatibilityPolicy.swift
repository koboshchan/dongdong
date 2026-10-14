public enum CompatibilityPolicy {
    /// Task-specified build identifiers, not a capability or device validation claim.
    public static func evaluate(version: SystemVersion, build: String?) -> CompatibilityStatus {
        guard version == SystemVersion(major: 27, minor: 0, patch: 0) else {
            return .unsupportedVersion
        }
        guard let build, !build.isEmpty else { return .buildUnavailable }
        switch build {
        case "24A5355q": return .supported(developerBeta: 1)
        case "24A5370h": return .supported(developerBeta: 2)
        case "24A5380h": return .supported(developerBeta: 3)
        case "24A5390f": return .supported(developerBeta: 4)
        default: return .unsupportedBuild
        }
    }
}
