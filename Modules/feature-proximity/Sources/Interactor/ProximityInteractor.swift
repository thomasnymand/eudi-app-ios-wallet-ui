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
import logic_api
import logic_business
import CoreImage.CIFilterBuiltins
import UIKit

public enum ProximityPartialState {
  case success
  case failure(Error)
}

public enum ProximityQrCodePartialState {
  case success(UIImage)
  case failure(Error)
}

public protocol ProximityInteractorType {
  func doWork() async -> ProximityPartialState
  func generateQRCode() async -> ProximityQrCodePartialState
}

public final actor ProximityInteractor: ProximityInteractorType {

  public init() {}

  public func generateQRCode() async -> ProximityQrCodePartialState {

    let qrCode = UUID().uuidString

    let filter = CIFilter.qrCodeGenerator()

    guard let data = qrCode.data(using: .ascii, allowLossyConversion: false) else {
      return .failure(RuntimeError.genericError)
    }
    filter.message = data

    guard let ciimage = filter.outputImage else {
      return .failure(RuntimeError.genericError)
    }
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    let scaledCIImage = ciimage.transformed(by: transform)
    let uiimage = UIImage(ciImage: scaledCIImage)

    guard let pngData = uiimage.pngData(), let qrImage = UIImage(data: pngData) else {
      return .failure(RuntimeError.genericError)
    }

    return .success(qrImage)
  }

  public func doWork() async -> ProximityPartialState {
    do {
      try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
      return .success
    } catch {
      return .failure(error)
    }
  }
}
