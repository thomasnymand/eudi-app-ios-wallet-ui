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

public struct SplashBackground: View {

  let isAnimating: Bool

  public init(isAnimating: Bool = false) {
    self.isAnimating = isAnimating
  }

  public var body: some View {
    LinearGradient(gradient: Gradient(colors: [ThemeManager.shared.color.lightGradientStart,
                                               ThemeManager.shared.color.lightGradientEnd]),
                   startPoint: .top,
                   endPoint: .bottom)
    .edgesIgnoringSafeArea(.all)
    .overlay {
      VStack {
        ThemeManager.shared.image.logo
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: isAnimating ? getScreenRect().width / 3 : getScreenRect().width / 0.5)
          .opacity(isAnimating ? 1.0 : 0.5)
      }
    }
  }
}
