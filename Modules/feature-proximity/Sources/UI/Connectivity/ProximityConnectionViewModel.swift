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
import Foundation
import logic_ui
import UIKit

struct ProxmityConnectivityState: ViewState {
  let error: ContentError.Config?
  let qrImage: UIImage?
}

@MainActor
final class ProximityConnectionViewModel<Router: RouterHostType, Interactor: ProximityInteractorType>: BaseViewModel<Router, ProxmityConnectivityState> {

  private let interactor: Interactor

  init(router: Router, interactor: Interactor) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(error: nil, qrImage: nil)
    )
  }

  func initialize() async {
    await generateQRCode()
    await onConnectionSuccess()
  }

  func goBack() {
    router.pop()
  }

  // MARK: - TODO needs to change to actual implementation, temporarily will move to request screen
  private func onConnectionSuccess() async {
    switch await interactor.doWork() {
    case .success:
      router.push(with: .proximityRequest)
    case .failure(let error):
      setNewState(
        error: .init(
          description: .custom(error.localizedDescription),
          cancelAction: self.router.pop()
        )
      )
    }
  }

  private func generateQRCode() async {
    switch await interactor.generateQRCode() {
    case .success(let qrImage):
      setNewState(qrImage: qrImage)
    case .failure(let error):
      setNewState(
        error: .init(
          description: .custom(error.localizedDescription),
          cancelAction: self.router.pop()
        )
      )
    }
  }

  private func setNewState(
    error: ContentError.Config? = nil,
    qrImage: UIImage? = nil
  ) {
    setState { previousState in
        .init(
          error: error,
          qrImage: qrImage ?? previousState.qrImage
        )
    }
  }
}
