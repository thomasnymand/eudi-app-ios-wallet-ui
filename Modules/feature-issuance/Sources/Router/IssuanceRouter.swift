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
import logic_ui
import logic_business

@MainActor
public final class IssuanceRouter {

  public static func resolve(module: FeatureIssuanceRouteModule, host: some RouterHost) -> AnyView {
    switch module {
    case .issuanceAddDocument(config: let config):
      AddDocumentView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            AddDocumentInteractor.self
          ),
          deepLinkController: DIGraph.resolver.force(
            DeepLinkController.self
          ),
          config: config
        )
      ).eraseToAnyView()
    case .issuanceDocumentDetails(config: let config):
      DocumentDetailsView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            DocumentDetailsInteractor.self
          ),
          config: config
        )
      ).eraseToAnyView()
    case .issuanceSuccess(config: let config, documentIdentifiers: let documentIdentifiers):
      DocumentSuccessView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            DocumentSuccessInteractor.self
          ),
          detailsInteractor: DIGraph.resolver.force(
            DocumentDetailsInteractor.self
          ),
          config: config,
          documentIdentifiers: documentIdentifiers
        )
      ).eraseToAnyView()
    case .credentialOfferRequest(config: let config):
      DocumentOfferView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            DocumentOfferInteractor.self
          ),
          config: config
        )
      ).eraseToAnyView()
    case .issuanceCode(config: let config):
      OfferCodeView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            DocumentOfferInteractor.self
          ),
          config: config
        )
      ).eraseToAnyView()
    }
  }
}
