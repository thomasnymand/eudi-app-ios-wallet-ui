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
import Foundation
import SwiftUI

public struct SuccessUiConfig {
  public let title: LocalizedStringKey
  public let subTitle: LocalizedStringKey
  public let icon: String
  public let caption: LocalizedStringKey?
  public let routeToPop: AppRoute?

  public init(
    title: LocalizedStringKey,
    subTitle: LocalizedStringKey,
    icon: String,
    caption: LocalizedStringKey? = nil,
    routeToPop: AppRoute? = nil
  ) {
    self.title = title
    self.icon = icon
    self.subTitle = subTitle
    self.caption = caption
    self.routeToPop = routeToPop
  }
}
