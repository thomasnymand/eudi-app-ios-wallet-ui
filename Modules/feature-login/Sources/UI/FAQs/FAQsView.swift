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
import logic_ui
import logic_resources

public struct FAQsView<Router: RouterHostType, Interactor: FAQsInteractorType>: View {

  @ObservedObject private var viewModel: FAQsViewModel<Router, Interactor>
  @State var userIsEditingAlias = false

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = .init(router: router, interactor: interactor)
  }

  public var body: some View {
    ContentScreen(canScroll: true) {

      ContentHeader {
        viewModel.goBack()
      }

      ScrollView(showsIndicators: false) {
        VStack(spacing: SPACING_LARGE_MEDIUM) {

          ContentTitle(title: .faqs)

          SearchBar(
            text: $viewModel.searchText,
            commited: $userIsEditingAlias,
            isLoading: viewModel.viewState.isLoading
          )

          ForEach(viewModel.viewState.filteredModels) { cell in
            ExpandableTextView(
              title: .custom(cell.value.title),
              content: .custom(cell.value.content),
              isloading: viewModel.viewState.isLoading
            ).transition(.opacity)
          }
        }
      }
      .disabled(viewModel.viewState.isLoading)
    }
    .task {
      await viewModel.fetchFAQs()
    }
    .background(Theme.shared.color.backgroundPaper)
  }
}
