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

public protocol ImageManagerProtocol {
  var logo: Image { get }
  var faceId: Image { get }
  var id: Image { get }
  var idStroke: Image { get }
  var nfc: Image { get }
  var touchId: Image { get }
  var user: Image { get }
  var arrowLeft: Image { get }
  var chevronUp: Image { get }
  var chevronDown: Image { get }
  var xmark: Image { get }
  var exclamationmarkCircle: Image { get }
  var circle: Image { get }
  var eye: Image { get }
  var eyeSlash: Image { get }
  var checkmarkCircle: Image { get }
  var checkmarkSquareFill: Image { get }
  var square: Image { get }
  var exclamationmarkOctagon: Image { get }
  var plus: Image { get }
  var share: Image { get }
  var warning: Image { get }
}

final class ImageManager: ImageManagerProtocol {

  enum ImageEnum: String {
    case faceId = "face-id"
    case id = "id"
    case idStroke = "id-stroke"
    case nfc = "nfc"
    case touchId = "touch-id"
    case user = "user"
    case logo = "logo"
    case arrowLeft = "arrow.left"
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case xmark = "xmark"
    case exclamationmarkCircle = "exclamationmark.circle"
    case circle = "circle.fill"
    case eye = "eye"
    case eyeSlash = "eye.slash"
    case checkmarkCircle = "checkmark.circle"
    case checkmarkSquareFill = "checkmark.square.fill"
    case square = "square"
    case exclamationmarkOctagon = "exclamationmark.octagon"
    case plus = "plus"
    case share = "iphone.and.arrow.forward"
    case warning = "ic-warning"
  }

  // MARK: - Properties

  var bundle: Bundle
  // MARK: - Lifecycle

  init(bundle: Bundle) {
    self.bundle = bundle
  }
  // MARK: - Images
  var faceId: Image {
    Image(ImageEnum.faceId.rawValue, bundle: bundle)
  }
  var id: Image {
    Image(ImageEnum.id.rawValue, bundle: bundle)
  }
  var idStroke: Image {
    Image(ImageEnum.idStroke.rawValue, bundle: bundle)
  }
  var nfc: Image {
    Image(ImageEnum.nfc.rawValue, bundle: bundle)
  }
  var touchId: Image {
    Image(ImageEnum.touchId.rawValue, bundle: bundle)
  }
  var user: Image {
    Image(ImageEnum.user.rawValue, bundle: bundle)
  }
  var logo: Image {
    Image(ImageEnum.logo.rawValue, bundle: bundle)
  }
  var arrowLeft: Image {
    Image(systemName: ImageEnum.arrowLeft.rawValue)
  }
  var chevronUp: Image {
    Image(systemName: ImageEnum.chevronUp.rawValue)
  }
  var chevronDown: Image {
    Image(systemName: ImageEnum.chevronDown.rawValue)
  }
  var xmark: Image {
    Image(systemName: ImageEnum.xmark.rawValue)
  }
  var exclamationmarkCircle: Image {
    Image(systemName: ImageEnum.exclamationmarkCircle.rawValue)
  }
  var circle: Image {
    Image(systemName: ImageEnum.circle.rawValue)
  }
  var eye: Image {
    Image(systemName: ImageEnum.eye.rawValue)
  }
  var eyeSlash: Image {
    Image(systemName: ImageEnum.eyeSlash.rawValue)
  }
  var checkmarkCircle: Image {
    Image(systemName: ImageEnum.checkmarkCircle.rawValue)
  }
  var checkmarkSquareFill: Image {
    Image(systemName: ImageEnum.checkmarkSquareFill.rawValue)
  }
  var square: Image {
    Image(systemName: ImageEnum.square.rawValue)
  }
  var exclamationmarkOctagon: Image {
    Image(systemName: ImageEnum.exclamationmarkOctagon.rawValue)
  }
  var plus: Image {
    Image(systemName: ImageEnum.plus.rawValue)
  }
  var share: Image {
    Image(systemName: ImageEnum.share.rawValue)
  }
  var warning: Image {
    Image(ImageEnum.warning.rawValue, bundle: bundle)
  }
}
