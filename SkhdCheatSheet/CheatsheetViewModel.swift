import Foundation
import SwiftUI

struct HotKey: Identifiable {
    var id = UUID()
    var binding: String
    var command: String
}

class CheatsheetViewModel: ObservableObject {
    @Published var hotkeys: [HotKey] = []
    @Published var filteredHotKeys: [HotKey] = []
    
    
    func convertToHotKeyType(line: String) -> HotKey{
        let separator: Character = ":"

        let parts = line.split(separator: separator).map {
            String($0).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        
        return HotKey(binding: String(parts[0]), command: String(parts[1]))
    }
    
    func parseHotKeys() -> [HotKey] {
        
        let configPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("/.skhdrc")

        var keyBindings : [HotKey] = []
        
        do {
            let fileContent = try String(contentsOf: configPath, encoding: .utf8)
                        
            let lines = fileContent.split(separator: "\n")
            for l in lines {
                if !l.hasPrefix("#") {
                    keyBindings.append(convertToHotKeyType(line: String(l)))
                }
            }
        } catch {
            // Handle error
            print("Error reading file: \(error)")
        }
        
        filteredHotKeys = keyBindings
        return keyBindings
    }
    
    
    func searchItems(with searchTerm: String) {
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
    
    func loadHotKeys() {
        self.hotkeys = parseHotKeys()
    }
}
