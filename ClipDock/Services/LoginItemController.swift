import AppKit
import ServiceManagement
import Combine

@MainActor
final class LoginItemController: ObservableObject {
    @Published private(set) var status = SMAppService.mainApp.status
    @Published private(set) var error: String?
    var isInstalled: Bool {
        Self.isInstalledApp(Bundle.main.bundleURL, home: FileManager.default.homeDirectoryForCurrentUser)
    }
    var requested: Bool { status == .enabled || status == .requiresApproval }
    var description: String {
        if !isInstalled { return "Install ClipDock in Applications and launch that copy before enabling login startup." }
        switch status {
        case .enabled: return "Registered to launch at your next login."
        case .requiresApproval: return "Waiting for approval in System Settings → General → Login Items."
        case .notRegistered: return "Launch at login is off."
        case .notFound: return "macOS could not find this login item. Try registering this installed copy again."
        @unknown default: return "Login item status is unavailable."
        }
    }
    nonisolated static func isInstalledApp(_ url: URL, home: URL) -> Bool {
        let app = url.resolvingSymlinksInPath().standardizedFileURL
        let roots = [URL(fileURLWithPath: "/Applications", isDirectory: true), home.appendingPathComponent("Applications", isDirectory: true)]
        return app.pathExtension == "app" && roots.contains { app.deletingLastPathComponent() == $0.resolvingSymlinksInPath().standardizedFileURL }
    }
    func refresh() { status = SMAppService.mainApp.status }
    func setEnabled(_ enabled: Bool) {
        error = nil; refresh()
        guard !enabled || isInstalled else { error = description; return }
        do {
            if enabled {
                if status != .enabled && status != .requiresApproval { try SMAppService.mainApp.register() }
            } else if status != .notRegistered { try SMAppService.mainApp.unregister() }
            refresh()
            if status == .requiresApproval { SMAppService.openSystemSettingsLoginItems() }
        } catch {
            refresh()
            self.error = "Could not update launch at login: \(error.localizedDescription)"
        }
    }
}
