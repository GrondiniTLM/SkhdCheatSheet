import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = CheatsheetViewModel()
    @State private var searchTerm: String = ""

    
    var body: some View {
        List(viewModel.filteredHotKeys) { hotkey in
            VStack(alignment: .leading) {
                Text(hotkey.binding).font(.headline)
                Text(hotkey.command).font(.subheadline)
            }
        }
        .onAppear {
            viewModel.loadHotKeys()
        }
        .navigationTitle("HotKeys")
            .searchable(text: $searchTerm, prompt: "Search hotkey")
            .onChange(of: searchTerm) { newValue in
                viewModel.searchItems(with: newValue)
            }
    }
}

// Preview provider for SwiftUI previews in Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
