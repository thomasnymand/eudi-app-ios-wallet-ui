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
      toolbarContent: ToolBarContent(
        trailingActions: [
          Action(
            title: LocalizableString.shared.get(
              with: .cancelButton
            ).capitalizedFirst()
          ) {
            viewModel.onShowCancelModal()
          }
        ],
        leadingActions: [
          Action(
            title: LocalizableString.shared.get(
              with: .issueButton
            ).capitalizedFirst()
          ) {
            viewModel.onIssueDocuments()
          }
        ]
      )
    ) {
      content(
        viewState: viewModel.viewState,
        imageSize: getScreenRect().width / 4
      )
    }
    .sheetDialog(
      isPresented: $viewModel.isCancelModalShowing
    ) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .cancelIssueSheetTitle,
            caption: .cancelIssueSheetCaption
          )

          WrapButtonView(style: .primary, title: .cancelIssueSheetContinue, onAction: viewModel.onShowCancelModal())
          WrapButtonView(style: .secondary, title: .cancelButton, onAction: viewModel.onPop())
        }
      }
    }
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
    .typography(Theme.shared.font.bodyMedium)
    .fontWeight(.medium) +
  Text(" ") +
  Text(LocalizableString.shared.get(
    with: .issuerWantWalletAddition
  ))
  .typography(Theme.shared.font.bodyMedium)
}

@MainActor
@ViewBuilder
private func content(
  viewState: DocumentOfferViewState,
  imageSize: CGFloat
) -> some View {

  title(viewState: viewState)

  VSpacer.small()

  if viewState.documentOfferUiModel.uiOffers.isEmpty {
    noDocumentsFound(imageSize: imageSize)
  } else {
    ScrollView {
      VStack(spacing: SPACING_SMALL) {
        ForEach(viewState.documentOfferUiModel.uiOffers) { cell in
          WrapCardView {
            DocumentOfferCellView(
              cellModel: cell,
              isLoading: viewState.isLoading
            )
          }
        }

        VSpacer.small()

        Text(
          LocalizableString.shared.get(
            with: .issuer
          ).localizedUppercase
        )
        .typography(Theme.shared.font.bodySmall)
        .fontWeight(.medium)
        .foregroundStyle(Theme.shared.color.onSurface)
        .frame(maxWidth: .infinity, alignment: .leading)
        .shimmer(isLoading: viewState.isLoading)

        CardViewWithLogo(
          icon: .image(viewState.issuerData.icon),
          title: viewState.issuerData.title,
          isVerified: viewState.issuerData.isVerified,
          isLoading: viewState.isLoading
        )
      }
      .padding(.top)
    }
    .bottomFade()
  }

  Spacer()
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
