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

public struct TappableCellView: View {
  public let title: String
  public let subtitle: String
  public let action: () -> Void

  public init(title: String, subtitle: String, action: @escaping () -> Void) {
    self.title = title
    self.subtitle = subtitle
    self.action = action
  }

  public var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text(title)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundColor(Theme.shared.color.onSurface)
          .lineLimit(1)
          .minimumScaleFactor(0.8)
        Spacer()
        Text(subtitle)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundColor(Theme.shared.color.onSurface)
          .lineLimit(1)
          .minimumScaleFactor(0.8)
        Theme.shared.image.chevronRight
      }
      .padding(Theme.shared.dimension.padding)
      Divider()
        .background(Theme.shared.color.onSurface)
        .padding(.horizontal, Theme.shared.dimension.padding)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      action()
    }
  }
}
