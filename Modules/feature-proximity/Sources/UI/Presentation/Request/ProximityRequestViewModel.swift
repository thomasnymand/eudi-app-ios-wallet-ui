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

import feature_common
import logic_business

@MainActor
final class ProximityRequestViewModel<Router: RouterHostType, Interactor: ProximityInteractorType>: BaseRequestViewModel<Router> {

  private let interactor: Interactor

  init(
    router: Router,
    interactor: Interactor
  ) {
    self.interactor = interactor
    super.init(router: router)
    
    interactor.presentationSessionCoordinator.presentationStatePublisher.sink { state in
      switch state {
      case .error(let walletError):
        self.onError(with: walletError)
      default:
        ()
      }

    }
    .store(in: &cancellables)
  }

  override func doWork() async {
    self.onStartLoading()
    switch await interactor.onRequestReceived() {
    case .success(let items, title: let tite, caption: let caption, dataRequestInfo: let dataRequestInfo, relyingParty: let relyingParty):
      self.onReceivedItems(with: items, title: .custom(tite), dataRequestInfo: .custom(dataRequestInfo))
    case .failure(let error):
      self.onError(with: error)
    }
  }

  override func onShare() {
    switch interactor.onResponsePrepare(requestItems: viewState.items) {
    case .success:
      guard let route = getSuccessRoute() else { return }
      router.push(with: route)
    case .failure(let error):
      self.onError(with: error)
    }

  }

  override func getSuccessRoute() -> AppRoute? {
    .biometry(
      config: UIConfig.Biometry(
        title: getTitle(),
        caption: .requestDataShareBiometryCaption,
        quickPinOnlyCaption: .requestDataShareBiometryCaption,
        navigationSuccessConfig: .init(
          screen: .proximityLoader(
            getRelyingParty(),
            presentationCoordinator: interactor.presentationSessionCoordinator
          ),
          navigationType: .push
        ),
        navigationBackConfig: .init(
          screen: .proximityRequest(presentationCoordinator: interactor.presentationSessionCoordinator),
          navigationType: .pop
        ),
        isPreAuthorization: false,
        shouldInitializeBiometricOnCreate: true
      )
    )
  }

  override func getPopRoute() -> AppRoute? {
    return .dashboard
  }

  override func getTitle() -> LocalizableString.Key {
    viewState.title
  }

  override func getCaption() -> LocalizableString.Key {
    viewState.caption
  }

  override func getDataRequestInfo() -> LocalizableString.Key {
    viewState.dataRequestInfo
  }

  override func getRelyingParty() -> String {
    viewState.relyingParty
  }

}
