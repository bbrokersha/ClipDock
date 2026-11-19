import SwiftUI
import ServiceManagement
#if SWIFT_PACKAGE
import ClipDockCore
#endif

struct GeneralSettingsView: View {
    @ObservedObject var store: ClipboardStore
    @StateObject private var login = LoginItemController()
    var body: some View {
        Section("Startup") {
            Toggle("Launch ClipDock at login", isOn: Binding(get: { login.requested }, set: { login.setEnabled($0) }))
                .disabled(!login.isInstalled && !login.requested)
            Text(login.description).font(.caption).foregroundStyle(.secondary)
            if let error = login.error { Text(error).font(.caption).foregroundStyle(.red) }
            Button("Open Login Items Settings…") { SMAppService.openSystemSettingsLoginItems() }
            Toggle("Show Dock icon", isOn: $store.settings.showDockIcon)
        }
        .onAppear { login.refresh() }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in login.refresh() }
        Section("Panel") {
            Toggle("Close panel after launching an app", isOn: $store.settings.closeAfterAction)
            Picker("Panel position", selection: $store.settings.panelPosition) {
                ForEach(PanelPosition.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
        }
        Section {
            Text("ClipDock is always available from the menu bar and your global shortcut.").font(.callout).foregroundStyle(.secondary)
        }
    }
}
