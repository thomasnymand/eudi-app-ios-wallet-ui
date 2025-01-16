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

public struct WrapListItemView: View {
  private let listItem: ListItemData
  private let action: (() -> Void)?
  private let mainTextVerticalPadding: CGFloat?
  private let minHeight: Bool

  public init(
    listItem: ListItemData,
    mainTextVerticalPadding: CGFloat? = nil,
    minHeight: Bool = true,
    action: (() -> Void)? = nil
  ) {
    self.listItem = listItem
    self.mainTextVerticalPadding = mainTextVerticalPadding
    self.minHeight = minHeight
    self.action = action
  }

  public var body: some View {
    HStack(alignment: .center, spacing: SPACING_MEDIUM) {
      if let leadingIcon = listItem.leadingIcon {

        AsyncImage(
          url: listItem.leadingIcon?.0
        ) { image in
         image
            .resizable()
            .scaledToFit()
        } placeholder: {
          if let leadingIconPlaceholder = leadingIcon.1 {
            leadingIconPlaceholder
              .resizable()
              .scaledToFit()
              .frame(width: 40, height: 40)
          }
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
      }

      VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
        if let overlineText = listItem.overlineText {
          Text(overlineText)
            .font(Theme.shared.font.labelMedium.font)
            .foregroundStyle(listItem.overlineTextColor)
            .lineLimit(1)
            .truncationMode(.tail)
        }

        Text(listItem.mainText)
          .font(Theme.shared.font.bodyLarge.font)
          .foregroundStyle(Theme.shared.color.onSurface)
          .fontWeight(listItem.mainStyle == .plain ? .medium : .bold)
          .lineLimit(1)
          .truncationMode(.tail)
          .if(listItem.isBlur) {
            $0.blur(radius: 4, opaque: false)
          }

        if let supportingText = listItem.supportingText {
          Text(supportingText)
            .font(Theme.shared.font.bodyMedium.font)
            .foregroundStyle(listItem.supportingTextColor)
            .lineLimit(1)
            .truncationMode(.tail)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      if let trailingContent = listItem.trailingContent {
        switch trailingContent {
        case .icon(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .foregroundColor(Color.accentColor)

        case .checkbox(let enabled, let isChecked, let onToggle):
          WrapCheckbox(
            checkboxData: CheckboxData(
              isChecked: isChecked,
              enabled: enabled,
              onCheckedChange: { _ in
                onToggle(!isChecked)
              }))
        }
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      action?()
    }
    .padding(.all, mainTextVerticalPadding != nil ? mainTextVerticalPadding : SPACING_MEDIUM)
    .if(minHeight) {
      $0.frame(minHeight: 80, alignment: .leading)
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: "Main Text",
          overlineText: "Overline Text",
          supportingText: "Valid until: 22 March 2030",
          leadingIcon: (nil, Image(systemName: "star")),
          trailingContent: .icon(Image(systemName: "chevron.right"))
        ),
        action: {}
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: "Another Item",
          overlineText: nil,
          supportingText: "Additional Info",
          leadingIcon: nil
        )
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: "Another Item",
          overlineText: nil,
          supportingText: "Additional Info",
          leadingIcon: (nil, Image(systemName: "heart"))
        )
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: "Another Item",
          overlineText: "Overline Texr",
          supportingText: "Additional Info",
          overlineTextColor: Theme.shared.color.error,
          leadingIcon: (nil, Image(systemName: "heart"))
        )
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: "Main Text",
          overlineText: "Overline Text",
          supportingText: "Valid until: 22 March 2030",
          leadingIcon: (nil, Image(systemName: "star")),
          trailingContent: .checkbox(true, true) { _ in }
        ),
        action: {}
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: "Another Item",
          trailingContent: .icon(Image(systemName: "plus"))
        )
      )
    }
  }
  .padding()
}
