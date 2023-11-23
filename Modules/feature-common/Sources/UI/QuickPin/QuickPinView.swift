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

public struct QuickPinView<Router: RouterHostType, Interactor: QuickPinInteractorType>: View {

  @ObservedObject var viewModel: QuickPinViewModel<Router, Interactor>

  public init(with router: Router, interactor: Interactor, config: any UIConfigType) {
    self.viewModel = .init(router: router, interactor: interactor, config: config)
  }

  public var body: some View {
    ContentScreen {

      if viewModel.viewState.isCancellable {
        ContentHeader(
          dismissIcon: ThemeManager.shared.image.xmark,
          onBack: { viewModel.onShowCancellationModal() }
        )
      }

      ContentTitle(
        title: viewModel.viewState.title,
        caption: viewModel.viewState.caption,
        topSpacing: viewModel.viewState.isCancellable ? .withToolbar : .withoutToolbar
      )

      VSpacer.large()

      pinView

      Spacer()

      WrapButtonView(
        style: .primary,
        title: viewModel.viewState.button,
        isLoading: false,
        isEnabled: viewModel.viewState.isButtonActive,
        onAction: viewModel.onButtonClick()
      )
    }
    .sheetDialog(isPresented: $viewModel.isCancelModalShowing) {
      VStack(spacing: SPACING_MEDIUM) {

        ContentTitle(
          title: .quickPinUpdateCancellationTitle,
          caption: .quickPinUpdateCancellationCaption
        )

        WrapButtonView(
          style: .primary,
          title: .quickPinUpdateCancellationContinue,
          onAction:
            viewModel.onShowCancellationModal()
        )
        WrapButtonView(
          style: .secondary,
          title: .cancelButton,
          onAction: viewModel.onPop()
        )
      }
    }
  }

  private var pinView: some View {
    VStack(spacing: .zero) {

      PinTextField(
        numericText: $viewModel.uiPinInputField,
        maxDigits: 4,
        isSecureEntry: true,
        canFocus: .constant(true),
        shouldUseFullScreen: false,
        hasError: viewModel.viewState.pinError != nil
      )

      VSpacer.mediumSmall()

      if let error = viewModel.viewState.pinError {
        HStack {
          Text(error)
            .typography(ThemeManager.shared.font.bodyMedium)
            .foregroundColor(ThemeManager.shared.color.error)
          Spacer()
        }
      }
    }
  }
}
