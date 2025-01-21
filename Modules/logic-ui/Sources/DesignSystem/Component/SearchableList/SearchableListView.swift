/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import SwiftUI
import logic_resources

struct SearchableModifier: ViewModifier {
  @Binding var searchText: String
  let placeholder: String
  let backgroundColor: Color?
  let onSearchTextChange: (String) -> Void

  func body(content: Content) -> some View {
    VStack {
      CustomSearchBar(
        text: $searchText,
        placeholder: placeholder
      )
      .padding(.horizontal)
      .background(backgroundColor)

      content
        .onChange(of: searchText) { newValue in
          onSearchTextChange(newValue)
        }
    }
  }
}

// MARK: - Custom View Extension
public extension View {
  func searchable(
    searchText: Binding<String>,
    placeholder: String = "Search",
    backgroundColor: Color? = nil,
    onSearchTextChange: @escaping (String) -> Void
  ) -> some View {
    modifier(
      SearchableModifier(
        searchText: searchText,
        placeholder: placeholder,
        backgroundColor: backgroundColor,
        onSearchTextChange: onSearchTextChange
      )
    )
  }
}

// MARK: - Custom Search Bar for iOS 16
struct CustomSearchBar: UIViewRepresentable {
  @Binding var text: String
  let placeholder: String

  class Coordinator: NSObject, UISearchBarDelegate {
    @Binding var text: String

    init(text: Binding<String>) {
      _text = text
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      text = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      text = ""
      searchBar.resignFirstResponder()
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(text: $text)
  }

  func makeUIView(context: Context) -> UISearchBar {
    let searchBar = UISearchBar()
    searchBar.placeholder = placeholder
    searchBar.delegate = context.coordinator
    searchBar.autocapitalizationType = .none

    searchBar.backgroundImage = UIImage()
    searchBar.searchTextField.backgroundColor = UIColor(Theme.shared.color.surfaceContainer)

    return searchBar
  }

  func updateUIView(_ uiView: UISearchBar, context: Context) {
    uiView.text = text
  }
}

#Preview {
  var todayTransactions: [ListItemData] = [
    .init(
      mainText: "TravelBook",
      overlineText: "5 minutes ago",
      supportingText: "Completed",
      overlineTextColor: .green,
      trailingContent: .icon(Image(systemName: "chevron.right"))
    ),
    .init(
      mainText: "AirBNB",
      overlineText: "11:05 AM",
      supportingText: "Completed",
      overlineTextColor: .green,
      trailingContent: .icon(Image(systemName: "chevron.right"))
    ),
    .init(
      mainText: "Natural Bank VISA",
      overlineText: "11:05 AM",
      supportingText: "Failed",
      overlineTextColor: .red,
      trailingContent: .icon(Image(systemName: "chevron.right"))
    )
  ]

  NavigationView {
    WrapListView(
      sections: [
        (header: "GOVERNMENT", items: todayTransactions)
      ],
      style: .plain,
      hideRowSeperators: true,
      listRowBackground: .clear,
      rowContent: { transaction in
        WrapCardView {
          WrapListItemView(
            listItem: transaction
          )
        }
      }
    )
    .searchable(
      searchText: .constant(""),
      placeholder: "Search"
    ) { _ in }
  }
}
