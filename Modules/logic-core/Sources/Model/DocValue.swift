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
import Foundation
import SwiftUI

public enum DocValue {
  case string(String)
  case unavailable(String)
  case mandatory(Any)
  case image(Image)

  public var string: String? {
    switch self {
    case .string(let string):
      return string
    case .unavailable(let string):
      return string
    case .mandatory(let item):
      guard let item = item as? String else {
        return nil
      }
      return item
    default:
      return nil
    }
  }

  public var image: Image? {
    switch self {
    case .image(let image):
      return image
    case .mandatory(let item):
      guard let item = item as? Image else {
        return nil
      }
      return item
    default:
      return nil
    }
  }
}
