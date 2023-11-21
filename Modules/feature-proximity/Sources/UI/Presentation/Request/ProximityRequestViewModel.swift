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
  }

  override func doWork() async {
    self.onStartLoading()
    switch await interactor.onRequestReceived() {
    case .success(let array):
      self.onReceivedItems(with: array)
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
    //    if let verifierMessage = interactor.presentationSession.readerCertIssuerMessage {
    //      return .custom(verifierMessage)
    //    }
    return .requestDataTitle(["EUDI Conference"])
  }

  override func getCaption() -> LocalizableString.Key {
    //    if let validationMessage = interactor.presentationSession.readerCertValidationMessage {
    //      return .custom(validationMessage)
    //    }
    return .requestDataCaption
  }

  override func getDataRequestInfo() -> LocalizableString.Key {
    .requestDataInfoNotice
  }

  override func getRelyingParty() -> String {
    "EUDI Conference"
  }

}
