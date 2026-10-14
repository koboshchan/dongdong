import SwiftUI
import CompatibilityCore

struct CompatibilityView: View {
    let snapshot: SystemSnapshot

    var body: some View {
        NavigationStack {
            Form {
                Section("Compatibility") {
                    Label(
                        snapshot.status.title,
                        systemImage: snapshot.status.isSupported ? "checkmark.circle" : "exclamationmark.circle"
                    )
                    .font(.headline)
                    .accessibilityIdentifier("compatibilityStatus")
                    Text(snapshot.status.explanation)
                        .foregroundStyle(.secondary)
                }

                Section("This device") {
                    LabeledContent("iOS version", value: snapshot.version.displayText)
                        .accessibilityIdentifier("detectedVersion")
                    LabeledContent("System build", value: snapshot.build ?? "Unavailable")
                        .accessibilityIdentifier("detectedBuild")
                }

                Section {
                    Button("Replace file", action: placeholderAction)
                        .frame(minHeight: 44)
                        .disabled(true)
                        .accessibilityIdentifier("replaceFile")
                        .accessibilityHint("Permanently unavailable. This app cannot replace files.")
                } header: {
                    Text("Placeholder")
                } footer: {
                    Text("Disabled on every device, including supported builds. This app only reads the system version and build. It does not replace files.")
                }
            }
            .navigationTitle("dongdong")
        }
    }

    // Intentionally empty even if invoked outside the disabled control.
    private func placeholderAction() {}
}

#Preview("Supported") {
    CompatibilityView(snapshot: .init(version: .init(major: 27, minor: 0, patch: 0), build: "24A5380h"))
}

#Preview("Unsupported") {
    CompatibilityView(snapshot: .init(version: .init(major: 27, minor: 2, patch: 0), build: "Unknown"))
}
