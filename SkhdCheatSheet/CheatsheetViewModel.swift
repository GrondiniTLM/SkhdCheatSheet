import Foundation
import SwiftUI


class CheatsheetViewModel: ObservableObject {
    @Published var keyBindingGroups: [KeyBindingGroup] = []
    // @Published var filteredHotKeys: [KeyBinding] = []
    
    
    /* func searchItems(with searchTerm: String) {
            if searchTerm.isEmpty {
                filteredHotKeys = hotkeys
            } else {
                let lowercasedSearchTerm = searchTerm.lowercased()
                filteredHotKeys = hotkeys.filter { item in
                    return item.binding.lowercased().contains(lowercasedSearchTerm) ||
                        item.command.lowercased().contains(lowercasedSearchTerm)
                }
            }
        }
     */
    
    func loadHotKeys() {
        self.keyBindingGroups = parseConfig()
    }
}
