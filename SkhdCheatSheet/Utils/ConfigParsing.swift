import Foundation
import SwiftUI

struct KeyBinding: Identifiable {
    var id = UUID()
    var binding: String
    var command: String
}

struct KeyBindingGroup: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var keyBindings: [KeyBinding]
    var isExpanded: Bool = true
}

func getCheatSheetSubstr(configPath: URL) -> String {
    var output = ""
    
    do {
        let fileContent = try String(contentsOf: configPath, encoding: .utf8)
        
        var inConfig = false
                    
        let lines = fileContent.split(separator: "\n")
        for line in lines {
            
            if line.contains("[CheatSheet.End]") {
                inConfig = false
            }
            
            if inConfig {
                output += String(line + "\n")
            }
            
            if line.contains("[CheatSheet.Start]"){
                inConfig = true
            }
        }
    } catch {
        // Handle error
        print("Error reading file: \(error)")
    }
    
    return output
}

func spliceGroupDefinition(_ str: inout String) -> String {
    
    var groupSubstr = ""
    if let start = str.range(of: "[")?.lowerBound, let end = str.range(of: "]")?.upperBound {
        let range = start..<end
        groupSubstr = String(str[start..<end])

        str.removeSubrange(range)
       
    }
    
    return groupSubstr
}

func buildKeyBindingGroup(rawStr: String) -> KeyBindingGroup? {
    
    var keyBindingGroupObject : KeyBindingGroup;
    let cleanedStr = rawStr.filter { $0 != "#" && $0 != "\n"}
    
    if let start = cleanedStr.range(of: "{")?.lowerBound, let end = cleanedStr.range(of: "}")?.upperBound {
        
        let jsonConfigStr = String(cleanedStr[start..<end])
        let jsonData = jsonConfigStr.data(using: .utf8)
        
        do {
            if let configObject = try JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any] {
                print("config object:", configObject)

                keyBindingGroupObject = KeyBindingGroup(name: configObject["name"] as! String, description: configObject["description"] as! String, keyBindings: [])
                
                return keyBindingGroupObject
            }
        } catch {
            print("Error: Cannot convert JSON string to JSON object:", error)
        }
    }
    
    return nil
}

func buildKeyBinding(line: Substring) -> KeyBinding? {
    
    var components : [Substring] = line.split(separator: ":")
    
    for index in components.indices {
        components[index] = Substring(String(components[index]).trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    if components.count >= 2 {
        return KeyBinding(binding: String(components[0]), command: String(components[1]))
    }
    
    return nil
}

func parseGroup(rawGroup: String) -> KeyBindingGroup? {
    
    var content = rawGroup
    var groupSubstr = spliceGroupDefinition(&content)
    var keyBindingGroup : KeyBindingGroup? = buildKeyBindingGroup(rawStr: groupSubstr)
    
    let lines = content.split(separator: "\n")

    for line in lines {
        if line != "" {
            let keyBinding : KeyBinding? = buildKeyBinding(line: line)
            if keyBinding != nil {
                keyBindingGroup?.keyBindings.append(keyBinding!)
            }
        }
    }
    
    return keyBindingGroup
}

func getGroupSubstrs(content: String) -> [String] {
    
    
    let pattern = "\\[CheatSheet\\.Group[\\s\\S]*?\\[CheatSheet\\.EndGroup\\]"
    let regex = try! NSRegularExpression(pattern: pattern)
    let results = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))

    let substrings = results.map {
        String(content[Range($0.range, in: content)!])
    }

    return substrings
}

func parseConfig() -> [KeyBindingGroup] {
    
    var groups : [KeyBindingGroup] = []
    
    let configPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("/.skhdrc")
    
    let rawContent = getCheatSheetSubstr(configPath: configPath)
    let rawGroups = getGroupSubstrs(content: rawContent)
    
    
    for rawGroup in rawGroups {
        
        let binding : KeyBindingGroup? = parseGroup(rawGroup: rawGroup)
        
        if binding != nil {
            groups.append(binding!)

        }
    }
    
    return groups
}
