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
import logic_resources

public struct CardViewWithLogo: View {
  private let cornerRadius: CGFloat
  private let backgroundColor: Color
  private let icon: RemoteImageView.ImageContentOption
  private let title: LocalizableString.Key
  private let isVerified: Bool
  private let isLoading: Bool
  private let action: (() -> Void)?

  public init(
    cornerRadius: CGFloat = 13,
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    icon: RemoteImageView.ImageContentOption = .none,
    title: LocalizableString.Key,
    isVerified: Bool = false,
    isLoading: Bool = false,
    action: (() -> Void)? = nil
  ) {
    self.cornerRadius = cornerRadius
    self.backgroundColor = backgroundColor
    self.icon = icon
    self.title = title
    self.isVerified = isVerified
    self.isLoading = isLoading
    self.action = action
  }

  public var body: some View {
    WrapCardView(backgroundColor: backgroundColor) {
      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

        switch icon {
        case .none: EmptyView()
        case .remoteImage(let url, let image):
          HStack {
            RemoteImageView(
              url: url,
              icon: image,
              size: .init(
                width: Theme.shared.dimension.remoteImageIconSize,
                height: Theme.shared.dimension.remoteImageIconSize
              )
            )
            Spacer()
          }
        case .image(let image):
          HStack {
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: Theme.shared.dimension.remoteImageIconSize)
            Spacer()
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }

        Text(title)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.onSurface)
          .if(isVerified) {
            $0.leftImage(
              image: Theme.shared.image.relyingPartyVerified,
              spacing: Theme.shared.dimension.verifiedBadgeSpacing
            )
          }
          .if(icon.isNone) {
            $0.frame(maxWidth: .infinity, alignment: .leading)
          }
      }
      .padding(.all, SPACING_MEDIUM)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      action?()
    }
    .shimmer(isLoading: isLoading)
  }
}

#Preview {
  VStack(spacing: 16) {
    CardViewWithLogo(
      icon: .image(
        Image(
          systemName: "building.2.crop.circle.fill"
        )
        .renderingMode(.original)
      ),
      title: .custom("Hellenic Government")
    )

    CardViewWithLogo(
      icon: .image(
        Image(
          systemName: "building.2.crop.circle.fill"
        )
        .renderingMode(.original)
      ),
      title: .custom("Another Organization")
    )

    CardViewWithLogo(
      backgroundColor: Theme.shared.color.tertiary,
      icon: .image(
        Image(
          systemName: "building.2.crop.circle.fill"
        )
        .renderingMode(.original)
      ),
      title: .custom("Another Organization"),
      isVerified: true
    )
  }
  .padding()
}
