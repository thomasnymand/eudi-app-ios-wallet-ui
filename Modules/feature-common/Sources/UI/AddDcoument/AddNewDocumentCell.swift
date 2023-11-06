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
import SwiftUI
import logic_resources

public struct AddNewDocumentCell: View {

  let isEnabled: Bool
  let icon: Image
  let title: LocalizableString.Key
  let action: () -> Void

  public init(isEnabled: Bool, icon: Image, title: LocalizableString.Key, action: @escaping () -> Void) {
    self.isEnabled = isEnabled
    self.icon = icon
    self.title = title
    self.action = action
  }

  public var body: some View {
    HStack {
      Button(action: action) {
        icon
          .resizable()
          .foregroundColor(isEnabled ? Theme.shared.color.primary : Theme.shared.color.textDisabledDark)
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: 32)
        Text(title)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundColor(isEnabled ? Theme.shared.color.textPrimaryDark : Theme.shared.color.textDisabledDark)
        Spacer()
        Image(systemName: "plus")
          .font(.body.bold())
          .foregroundColor(isEnabled ? Theme.shared.color.primary : Theme.shared.color.textDisabledDark)
      }
      .disabled(!isEnabled)
      .padding(24)
      .background(Theme.shared.color.backgroundDefault)
      .tint(isEnabled ? nil : .gray)
      .clipShape(.rect(cornerRadius: Theme.shared.shape.small))
    }
  }
}
