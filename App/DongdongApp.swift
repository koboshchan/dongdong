import SwiftUI
import CompatibilityCore

@main
struct DongdongApp: App {
    private let snapshot = SystemInformationReader.snapshot()

    var body: some Scene {
        WindowGroup {
            CompatibilityView(snapshot: snapshot)
        }
    }
}
