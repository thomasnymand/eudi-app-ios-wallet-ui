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
import feature_common

struct DocumentOfferView<Router: RouterHost>: View {

  @ObservedObject var viewModel: DocumentOfferViewModel<Router>

  init(with viewModel: DocumentOfferViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      errorConfig: viewModel.viewState.error,
      navigationTitle: LocalizableString.shared.get(
        with: .addDocumentRequest
      ),
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState,
        imageSize: getScreenRect().width / 4
      )
    }
    .confirmationDialog(
      title: LocalizableString.shared.get(with: .cancelIssueSheetTitle),
      message: LocalizableString.shared.get(with: .cancelIssueSheetCaption),
      destructiveText: LocalizableString.shared.get(with: .cancelButton),
      baseText: LocalizableString.shared.get(with: .cancelIssueSheetContinue),
      isPresented: $viewModel.isCancelModalShowing,
      destructiveAction: {
        viewModel.onPop()
      },
      baseAction: {
        viewModel.onShowCancelModal()
      }
    )
    .task {
      await viewModel.initialize()
    }
    .onReceive(NotificationCenter.default.publisher(for: NSNotification.CredentialOffer)) { data in
      guard let payload = data.userInfo else {
        return
      }
      viewModel.handleNotification(with: payload)
    }
  }
}

@MainActor
@ViewBuilder
private func title(viewState: DocumentOfferViewState) -> some View {
  Text(viewState.documentOfferUiModel.issuerName)
    .typography(Theme.shared.font.bodyLarge)
    .fontWeight(.medium) +
  Text(" ") +
  Text(LocalizableString.shared.get(
    with: .issuerWantWalletAddition
  ))
  .typography(Theme.shared.font.bodyLarge)
}

@MainActor
@ViewBuilder
private func content(
  viewState: DocumentOfferViewState,
  imageSize: CGFloat
) -> some View {
  ScrollView {
    VStack(spacing: .zero) {
      ContentHeader(
        config: ContentHeaderConfig(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          ),
          description: LocalizableString.shared.get(with: .dataSharingTitle),
          mainText: LocalizableString.shared.get(with: .issuanceRequest).uppercased(),
          icon: .image(viewState.issuerData.icon),
          relyingPartyData: RelyingPartyData(
            isVerified: false,
            name: viewState.issuerData.title,
            description: LocalizableString.shared.get(with: .issuerWantWalletAddition)
          )
        )
      )

      if viewState.documentOfferUiModel.uiOffers.isEmpty {
        noDocumentsFound(imageSize: imageSize)
      } else {
        VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
          ForEach(viewState.documentOfferUiModel.uiOffers) { cell in
            WrapCardView {
              DocumentOfferCellView(
                cellModel: cell,
                isLoading: viewState.isLoading
              )
            }
          }

          Text(.shareDataReview)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.onSurface)
            .multilineTextAlignment(.leading)
          VSpacer.medium()
        }
      }
    }
  }
}

@MainActor
@ViewBuilder
private func noDocumentsFound(imageSize: CGFloat) -> some View {
  VStack(alignment: .center) {

    Spacer()

    VStack(alignment: .center, spacing: SPACING_MEDIUM) {

      Theme.shared.image.exclamationmarkCircle
        .renderingMode(.template)
        .resizable()
        .foregroundStyle(Theme.shared.color.onSurface)
        .frame(width: imageSize, height: imageSize)

      Text(.requestCredentialOfferNoDocument)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundColor(Theme.shared.color.onSurface)
        .multilineTextAlignment(.center)
    }

    Spacer()
  }
}

#Preview {
  let viewState = DocumentOfferViewState(
    isLoading: false,
    documentOfferUiModel: DocumentOfferUIModel.mock(),
    issuerData: IssuerDataUIModel.mock(),
    error: nil,
    config: UIConfig.Generic(
      arguments: ["uri": "uri"],
      navigationSuccessType: .push(.featureDashboardModule(.dashboard)),
      navigationCancelType: .pop
    ),
    offerUri: "offer uri",
    allowIssue: true,
    initialized: true
  )

  ContentScreenView {
    content(
      viewState: viewState,
      imageSize: UIScreen.main.bounds.width / 4
    )
  }
}

#Preview("No document") {
  let viewState = DocumentOfferViewState(
    isLoading: false,
    documentOfferUiModel: .init(
      issuerName: LocalizableString.shared.get(with: .unknownIssuer),
      txCode: nil,
      uiOffers: [],
      docOffers: []
    ),
    issuerData: IssuerDataUIModel.mock(),
    error: nil,
    config: UIConfig.Generic(
      arguments: ["uri": "uri"],
      navigationSuccessType: .push(.featureDashboardModule(.dashboard)),
      navigationCancelType: .pop
    ),
    offerUri: "offer uri",
    allowIssue: true,
    initialized: true
  )

  ContentScreenView {
    content(
      viewState: viewState,
      imageSize: UIScreen.main.bounds.width / 4
    )
  }
}
