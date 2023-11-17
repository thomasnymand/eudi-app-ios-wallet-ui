/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import logic_ui
import logic_business

struct DashboardState: ViewState {
  let isLoading: Bool
  let documents: [DocumentUIModel]
  let bearer: BearerUIModel
}

@MainActor
final class DashboardViewModel<Router: RouterHostType, Interactor: DashboardInteractorType, DeepLinkController: DeepLinkControllerType>: BaseViewModel<Router, DashboardState> {

  private let interactor: Interactor
  private let deepLinkController: DeepLinkController

  var bearerName: String {
    viewState.bearer.value.name
  }

  init(router: Router, interactor: Interactor, deepLinkController: DeepLinkController) {
    self.interactor = interactor
    self.deepLinkController = deepLinkController
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        documents: DocumentUIModel.mocks(),
        bearer: BearerUIModel.mock()
      )
    )
  }

  func fetch() async {
    switch await interactor.fetchDashboard() {
    case .success(let bearer, let documents):
      setNewState(
        isLoading: false,
        documents: documents,
        bearer: bearer
      )
      handleDeepLink()
    case .failure:
      setNewState(
        isLoading: false,
        documents: [],
        bearer: nil
      )
    }
  }

  func onDocumentDetails(documentId: String) {
    router.push(with: .documentDetails(docoumentId: documentId))
  }
  func onShare() {
    router.push(with: .proximityConnection(presentationSession: WalletKitController.shared.startPresentation(flow: .ble)))
  }

  func onAdd() {
    router.push(with: .addDocument)
  }

  private func handleDeepLink() {
    if let deepLink = deepLinkController.getPendingDeepLinkAction() {
      deepLinkController.handleDeepLinkAction(routerHost: router, deepLinkAction: deepLink)
    }
  }

  private func setNewState(
    isLoading: Bool? = nil,
    documents: [DocumentUIModel]? = nil,
    bearer: BearerUIModel? = nil
  ) {
    setState { previousSate in
        .init(
          isLoading: isLoading ?? previousSate.isLoading,
          documents: documents ?? previousSate.documents,
          bearer: bearer ?? previousSate.bearer
        )
    }
  }
}
