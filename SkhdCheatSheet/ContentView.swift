import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = CheatsheetViewModel()
    @State private var searchTerm: String = ""

    
    var body: some View {
        List(viewModel.keyBindingGroups) { group in
            Section(header: VStack(alignment: .leading) {
                Text(group.name)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                Text(group.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }, content: {
                
                ForEach(group.keyBindings) { keyBinding in
                    VStack(alignment: .leading) {
                        Text(keyBinding.binding).font(.headline)
                        Text(keyBinding.command).font(.subheadline)
                    }
                }
            })
        }
        .onAppear {
            viewModel.loadHotKeys()
        }
        .navigationTitle("HotKeys")
            /*.searchable(text: $searchTerm, prompt: "Search hotkey")
            .onChange(of: searchTerm) { newValue in
                viewModel.searchItems(with: newValue)
            }*/
    }
}

// Preview provider for SwiftUI previews in Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
