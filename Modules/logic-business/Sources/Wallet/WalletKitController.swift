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
import EudiWalletKit
import MdocDataModel18013
import Combine
import logic_resources

public protocol WalletKitControllerType {
  static var shared: WalletKitControllerType { get }
  var wallet: EudiWallet { get }
  var activeCoordinator: PresentationSessionCoordinatorType? { get }

  func startProximityPresentation() -> PresentationSessionCoordinatorType
  func stopPresentation()
}

public final class WalletKitController: WalletKitControllerType {

  public static let shared: WalletKitControllerType = WalletKitController()
  public let wallet = EudiWallet.standard

  public private(set) var activeCoordinator: PresentationSessionCoordinatorType?
  private var cancellables = Set<AnyCancellable>()

  public convenience init(string: String) {
    self.init()
  }

  internal init() {
    try? wallet.loadSampleData()
    wallet.userAuthenticationRequired = false
    wallet.trustedReaderCertificates = [Data(name: "scytales_root_ca", ext: "der")!]
  }

  public func startProximityPresentation() -> PresentationSessionCoordinatorType {
    self.stopPresentation()
    let session = wallet.beginPresentation(flow: .ble)
    let presentationSessionCoordinator = ProximityPresentationSessionCoordinator(session: session)
    self.activeCoordinator = presentationSessionCoordinator
    presentationSessionCoordinator.onSuccess {
      stopPresentation()
    }
    return presentationSessionCoordinator
  }

  public func stopPresentation() {
    self.cancellables.forEach {$0.cancel()}
    self.activeCoordinator = nil
  }

}

extension WalletKitControllerType {

  public func mandatoryFields(for documentType: DocumentIdentifier) -> [String] {
    switch documentType {
    case .EuPidDocType:
      return []
    case .IsoMdlModel:
      return IsoMdlModel.mandatoryKeys
    case .genericDocument(docType: let docType):
      return []
    }
  }

  public func valueForElementIdentifier(for documentType: DocumentIdentifier, elementIdentifier: String) -> String {
    var displayStrings = wallet.storage.mdocModels
      .compactMap({ $0 })
      .first(where: { $0.docType == documentType.rawValue })?.displayStrings

    if documentType == .IsoMdlModel, let mdl = wallet.storage.mdlModel {
      if elementIdentifier == IsoMdlModel.CodingKeys.portrait.rawValue || elementIdentifier == IsoMdlModel.CodingKeys.signatureUsualMark.rawValue {
        return "Image Data"
      }

      if let drivingPrivileges = mdl.drivingPrivileges {
        let flatString = drivingPrivileges.drivingPrivileges.reduce(into: "", {$0 += $1.vehicleCategoryCode +
          " expiry: \($1.expiryDate ?? "") issued at: \($1.issueDate ?? "")" + "\n"}).dropLast()

        displayStrings?.append(.init(name: "driving_privileges", value: String(flatString)))
      }

      mdl.ageOverXX.sorted(by: {$0.key < $1.key}).forEach { key, value in
        displayStrings?.append(.init(name: "age_over_\(key)", value: value ? "Yes" : "No"))
      }
    } else if documentType == .EuPidDocType,
              let pid = wallet.storage.pidModel {

      pid.ageOverXX.sorted(by: {$0.key < $1.key}).forEach { key, value in
        displayStrings?.append(.init(name: "age_over_\(key)", value: value ? "Yes" : "No"))
      }
    }

    let value = displayStrings?
      .first(where: { element in
        element.name == elementIdentifier
      })?.value

    return  value ?? LocalizableString.shared.get(with: .unavailableField)
  }

}
