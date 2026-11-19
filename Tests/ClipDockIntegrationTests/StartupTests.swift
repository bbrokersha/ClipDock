import XCTest
import ClipDockCore
@testable import ClipDock

final class StartupTests: XCTestCase {
    func testLoginInstallationLocations() {
        let home = URL(fileURLWithPath: "/Users/test", isDirectory: true)
        XCTAssertTrue(LoginItemController.isInstalledApp(URL(fileURLWithPath: "/Applications/ClipDock.app"), home: home))
        XCTAssertTrue(LoginItemController.isInstalledApp(home.appendingPathComponent("Applications/ClipDock.app"), home: home))
        XCTAssertFalse(LoginItemController.isInstalledApp(URL(fileURLWithPath: "/tmp/ClipDock.app"), home: home))
        XCTAssertFalse(LoginItemController.isInstalledApp(URL(fileURLWithPath: "/Volumes/ClipDock/ClipDock.app"), home: home))
    }
    @MainActor func testPanelAndGameShortcutsSurviveStoreRestart() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let panel = HotKey(keyCode: 19, modifiers: 768, label: "⇧⌘2")
        let game = HotKey(keyCode: 123, modifiers: 768, label: "⇧⌘←")
        let store = ClipboardStore(directory: directory)
        store.settings.hotKey = panel
        store.prepareForTermination()
        var library = ActionLibrary(); library.gameShortcut = game
        try library.save(to: directory.appendingPathComponent("actions.json"))
        let restored = ClipboardStore(directory: directory)
        XCTAssertEqual(restored.settings.hotKey, panel)
        XCTAssertEqual(try ActionLibrary.load(from: directory.appendingPathComponent("actions.json")).gameShortcut, game)
        restored.prepareForTermination()
    }
}
