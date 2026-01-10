

import SwiftUI
import SwiftData
import AppKit


// MARK: - App
@main
struct PredicateEditorApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: EntityPerson.self)
    }
}

