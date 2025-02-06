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

public protocol LocalizableStringType: Sendable {
  static var shared: LocalizableStringType { get }
  func get(with key: LocalizableString.Key) -> String
  func get(with key: LocalizableString.Key) -> LocalizedStringKey
}

public final class LocalizableString: LocalizableStringType {

  public static let shared: LocalizableStringType = LocalizableString()

  private let bundle: Bundle

  private init() {
    self.bundle = .assetsBundle
  }

  public func get(with key: Key) -> String {
    return switch key {
    case .dynamic(let key):
      bundle.localizedString(forKey: key)
    case .custom(let literal):
      literal
    case .space:
      " "
    case .search:
      bundle.localizedString(forKey: "search")
    case .genericErrorTitle:
      bundle.localizedString(forKey: "generic_error_title")
    case .genericErrorDesc:
      bundle.localizedString(forKey: "generic_error_description")
    case .biometryOpenSettings:
      bundle.localizedString(forKey: "biometry_open_settings")
    case .invalidQuickPin:
      bundle.localizedString(forKey: "invalid_quick_pin")
    case .tryAgain:
      bundle.localizedString(forKey: "try_again")
    case .shareButton:
      bundle.localizedString(forKey: "share_button")
    case .cancelButton:
      bundle.localizedString(forKey: "cancel_button")
    case .requestDataCaption:
      bundle.localizedString(forKey: "request_data_share_caption")
    case .requestDataInfoNotice:
      bundle.localizedString(forKey: "request_data_info_notice")
    case .requestDataTitle(let args):
      bundle.localizedStringWithArguments(forKey: "request_data_share_title", arguments: args)
    case .documentAdded:
      bundle.localizedString(forKey: "document_added")
    case .requestDataSheetCaption:
      bundle.localizedString(forKey: "request_data_sheet_caption")
    case .okButton:
      bundle.localizedString(forKey: "ok_button")
    case .shareDataReview:
      bundle.localizedString(forKey: "share_data_review_title")
    case .success:
      bundle.localizedString(forKey: "success")
    case .successfullySharedFollowingInformation:
      bundle.localizedString(forKey: "successfully_shared_following_information")
    case .incompleteRequestDataSelection:
      bundle.localizedString(forKey: "incomplete_request_data_selecting")
    case .addDoc:
      bundle.localizedString(forKey: "add_doc")
    case .showQRTap:
      bundle.localizedString(forKey: "show_qr_tap")
    case .welcomeBack(let args):
      bundle.localizedStringWithArguments(forKey: "welcome_back", arguments: args)
    case .viewDocumentDetails:
      bundle.localizedString(forKey: "view_document_details")
    case .pleaseWait:
      bundle.localizedString(forKey: "please_wait")
    case .requestDataShareQuickPinCaption:
      bundle.localizedString(forKey: "request_data_share_quick_pin_caption")
    case .requestDataShareBiometryCaption:
      bundle.localizedString(forKey: "request_data_share_biometry_caption")
    case .addDocumentTitle:
      bundle.localizedString(forKey: "add_document_title")
    case .addDocumentRequest:
      bundle.localizedString(forKey: "add_document_request")
    case .addDocumentSubtitle:
      bundle.localizedString(forKey: "add_document_subtitle")
    case .proximityConnectivityCaption:
      bundle.localizedString(forKey: "proxmity_connectivity_caption")
    case .unavailableField:
      bundle.localizedString(forKey: "unavailable_field")
    case .requestDataVerifiedEntity:
      bundle.localizedString(forKey: "request_data_verified_entity")
    case .requestDataVerifiedEntityMessage:
      bundle.localizedString(forKey: "request_data_verified_entity_message")
    case .moreOptions:
      bundle.localizedString(forKey: "more_options")
    case .changeQuickPinOption:
      bundle.localizedString(forKey: "change_quick_pin_option")
    case .quickPinSetTitle:
      bundle.localizedString(forKey: "quick_pin_set_title")
    case .quickPinSetCaptionOne:
      bundle.localizedString(forKey: "quick_pin_set_step_one_caption")
    case .quickPinSetCaptionTwo:
      bundle.localizedString(forKey: "quick_pin_set_step_two_caption")
    case .quickPinNextButton:
      bundle.localizedString(forKey: "quick_pin_next_button")
    case .quickPinConfirmButton:
      bundle.localizedString(forKey: "quick_pin_confirm_button")
    case .quickPinSetSuccess:
      bundle.localizedString(forKey: "quick_pin_set_success")
    case .loginTitle:
      bundle.localizedString(forKey: "login_title")
    case .loginCaptionQuickPinOnly:
      bundle.localizedString(forKey: "login_caption_quick_pin_only")
    case .loginCaption:
      bundle.localizedString(forKey: "login_caption")
    case .quickPinSetSuccessButton:
      bundle.localizedString(forKey: "quick_pin_set_success_button")
    case .quickPinDoNotMatch:
      bundle.localizedString(forKey: "quick_pin_dont_match")
    case .quickPinUpdateTitle:
      bundle.localizedString(forKey: "quick_pin_update_title")
    case .quickPinUpdateCaptionOne:
      bundle.localizedString(forKey: "quick_pin_update_step_one_caption")
    case .quickPinUpdateCaptionTwo:
      bundle.localizedString(forKey: "quick_pin_update_step_two_caption")
    case .quickPinUpdateCaptionThree:
      bundle.localizedString(forKey: "quick_pin_update_step_three_caption")
    case .quickPinUpdateSuccess:
      bundle.localizedString(forKey: "quick_pin_update_success")
    case .quickPinUpdateSuccessButton:
      bundle.localizedString(forKey: "quick_pin_update_success_button")
    case .quickPinUpdateCancellationTitle:
      bundle.localizedString(forKey: "quick_pin_update_cancellation_title")
    case .quickPinUpdateCancellationCaption:
      bundle.localizedString(forKey: "quick_pin_update_cancellation_caption")
    case .quickPinUpdateCancellationContinue:
      bundle.localizedString(forKey: "quick_pin_update_cancellation_continue")
    case .issuanceDetailsContinueButton:
      bundle.localizedString(forKey: "issuance_details_continue_button")
    case .successTitlePunctuated:
      bundle.localizedString(forKey: "issuance_success_title_punctuated")
    case .issuanceSuccessCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_success_caption", arguments: args)
    case .issuanceSuccessNextButton:
      bundle.localizedString(forKey: "issuance_success_next_button")
    case .unknownVerifier:
      bundle.localizedString(forKey: "unknown_verifier")
    case .unknownIssuer:
      bundle.localizedString(forKey: "unknown_issuer")
    case .genericIssuer:
      bundle.localizedString(forKey: "generic_issuer")
    case .yes:
      bundle.localizedString(forKey: "yes")
    case .no:
      bundle.localizedString(forKey: "no")
    case .scanQrCode:
      bundle.localizedString(forKey: "scan_qr_code")
    case .validUntil(let args):
      bundle.localizedStringWithArguments(forKey: "valid_until", arguments: args)
    case .bleDisabledModalTitle:
      bundle.localizedString(forKey: "ble_disabled_modal_title")
    case .bleDisabledModalCaption:
      bundle.localizedString(forKey: "ble_disabled_modal_content")
    case .bleDisabledModalButton:
      bundle.localizedString(forKey: "ble_disabled_modal_button")
    case .requestDataNoDocument:
      bundle.localizedString(forKey: "request_data_no_document")
    case .issuanceDetailsDeletionTitle(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_details_doc_deletion_title", arguments: args)
    case .deleteDocument:
      bundle.localizedString(forKey: "delete_document")
    case .issuanceDetailsDeletionCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_details_doc_deletion_caption", arguments: args)
    case .errorUnableFetchDocuments:
      bundle.localizedString(forKey: "error_unable_fetch_documents")
    case .errorUnableFetchDocument:
      bundle.localizedString(forKey: "error_unable_fetch_document")
    case .scannerQrTitle:
      bundle.localizedString(forKey: "scanner_qr_title")
    case .scannerQrCaption:
      bundle.localizedString(forKey: "scanner_qr_caption")
    case .cameraError:
      bundle.localizedString(forKey: "camera_error")
    case .missingPid:
      bundle.localizedString(forKey: "missing_pid")
    case .requestCredentialOfferTitle(let args):
      bundle.localizedStringWithArguments(forKey: "request_credential_offer_title", arguments: args)
    case .requestCredentialOfferCaption:
      bundle.localizedString(forKey: "request_credential_offer_caption")
    case .requestCredentialOfferNoDocument:
      bundle.localizedString(forKey: "request_credential_offer_no_document")
    case .unableToIssueAndStore:
      bundle.localizedString(forKey: "unable_to_issue_and_store_documents")
    case .issueButton:
      bundle.localizedString(forKey: "issue_button")
    case .cancelIssueSheetTitle:
      bundle.localizedString(forKey: "cancel_issuance_sheet_title")
    case .cancelIssueSheetCaption:
      bundle.localizedString(forKey: "cancel_issuance_sheet_caption")
    case .cancelIssueSheetContinue:
      bundle.localizedString(forKey: "cancel_issuance_sheet_continue")
    case .credentialOfferSuccessButton:
      bundle.localizedString(forKey: "credential_offer_success_button")
    case .credentialOfferSuccessCaption(let args):
      bundle.localizedStringWithArguments(forKey: "credential_offer_success_caption", arguments: args)
    case .credentialOfferPartialSuccessCaption(let args):
      bundle.localizedStringWithArguments(forKey: "credential_offer_partial_success_caption", arguments: args)
    case .issuanceCodeTitle(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_code_title", arguments: args)
    case .issuanceCodeCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_code_caption", arguments: args)
    case .transactionCodeFormatError(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_code_format_error", arguments: args)
    case .inProgress:
      bundle.localizedString(forKey: "in_progress")
    case .scopedIssuanceSuccessDeferredCaption:
      bundle.localizedString(forKey: "scoped_issuance_success_deferred_caption")
    case .scopedIssuanceSuccessDeferredCaptionDocName(let args):
      bundle.localizedStringWithArguments(forKey: "scoped_issuance_success_deferred_caption_docname", arguments: args)
    case .scopedIssuanceSuccessDeferredCaptionDocNameAndIssuer(let args):
      bundle.localizedStringWithArguments(forKey: "scoped_issuance_success_deferred_caption_docname_and_issuer_name", arguments: args)
    case .issuanceSuccessDeferredCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_success_deferred_caption", arguments: args)
    case .issuanceFailed:
      bundle.localizedString(forKey: "issuance_failed")
    case .pending:
      bundle.localizedString(forKey: "pending")
    case .deferredDocumentsIssuedModalTitle:
      bundle.localizedString(forKey: "deferred_document_issued_modal_title")
    case .defferedDocumentsIssuedModalCaption:
      bundle.localizedString(forKey: "deferred_document_issued_modal_caption")
    case .retrieveLogs:
      bundle.localizedString(forKey: "retrieve_logs")
    case .qrScanInformativeText:
      bundle.localizedString(forKey: "qr_scan_informative_text")
    case .unableToPresentAndShare:
      bundle.localizedString(forKey: "error_unable_present_documents")
    case .signDocument:
      bundle.localizedString(forKey: "sign_document")
    case .signDocumentSubtitle:
      bundle.localizedString(forKey: "sign_document_subtitle")
    case .selectDocument:
      bundle.localizedString(forKey: "select_document")
    case .itemNotFoundInStorage:
      bundle.localizedString(forKey: "item_not_found_in_storage")
    case .itemsNotFoundInStorage:
      bundle.localizedString(forKey: "items_not_found_in_storage")
    case .home:
      bundle.localizedString(forKey: "home")
    case .transactions:
      bundle.localizedString(forKey: "transactions")
    case .documents:
      bundle.localizedString(forKey: "documents")
    case .authenticateAuthoriseTransactions:
      bundle.localizedString(forKey: "authenticate_authorise_transactions")
    case .electronicallySignDigitalDocuments:
      bundle.localizedString(forKey: "electronically_sign_digital_documents")
    case .learnMore:
      bundle.localizedString(forKey: "learn_more")
    case .chooseFromList:
      bundle.localizedString(forKey: "choose_from_list")
    case .chooseFromListTitle:
      bundle.localizedString(forKey: "choose_from_list_title")
    case .addDocumentsToWallet:
      bundle.localizedString(forKey: "add_documents_to_wallet")
    case .details:
      bundle.localizedString(forKey: "details")
    case .dataSharingRequest:
      bundle.localizedString(forKey: "data_sharing_request")
    case .dataShared:
      bundle.localizedString(forKey: "data_shared")
    case .doneButton:
      bundle.localizedString(forKey: "done_button")
    case .dataSharingTitle:
      bundle.localizedString(forKey: "data_sharing_title")
    case .close:
      bundle.localizedString(forKey: "close")
    case .trustedRelyingParty:
      bundle.localizedString(forKey: "trusted_relying_party")
    case .trustedRelyingPartyDescription:
      bundle.localizedString(forKey: "trusted_relying_party_description")
    case .issuerWantWalletAddition:
      bundle.localizedString(forKey: "issuer_want_wallet_addition")
    case .issuer:
      bundle.localizedString(forKey: "issuer")
    case .alertAccessOnlineServices:
      bundle.localizedString(forKey: "alert_access_online_services")
    case .alertAccessOnlineServicesMessage:
      bundle.localizedString(forKey: "alert_access_online_services_message")
    case .alertSignDocumentsSafely:
      bundle.localizedString(forKey: "alert_sign_documents_safely")
    case .alertSignDocumentsSafelyMessage:
      bundle.localizedString(forKey: "alert_sign_documents_safely_message")
    case .authenticate:
      bundle.localizedString(forKey: "authenticate")
    case .inPerson:
      bundle.localizedString(forKey: "in_person")
    case .online:
      bundle.localizedString(forKey: "Online")
    case .fromDevice:
      bundle.localizedString(forKey: "from_device")
    case .autodashboardAuthenticateDialogMessage:
      bundle.localizedString(forKey: "autodashboard_authenticate_dialog_message")
    case .deleteButton:
      bundle.localizedString(forKey: "delete_button")
    case .savedToFavorites:
      bundle.localizedString(forKey: "saved_to_favorites")
    case .succesfullyAddedFollowingToWallet:
      bundle.localizedString(forKey: "succesfully_added_following_to_wallet")
    case .removedFromFavorites:
      bundle.localizedString(forKey: "removed_from_favorites")
    case .savedToFavoritesMessage:
      bundle.localizedString(forKey: "saved_to_favorites_message")
    case .removedFromFavoritesMessages:
      bundle.localizedString(forKey: "removed_from_favorites_messages")
    case .scannerQrTitleIssuing:
      bundle.localizedString(forKey: "scanner_qr_title_issuing")
    case .scannerQrTitlePresentation:
      bundle.localizedString(forKey: "scanner_qr_title_presentation")
    case .scannerQrCaptionIssuing:
      bundle.localizedString(forKey: "scanner_qr_caption_issuing")
    case .scannerQrCaptionPresentation:
      bundle.localizedString(forKey: "scanner_qr_caption_presentation")
    case .quickPinEnterPin:
      bundle.localizedString(forKey: "quick_pin_enter_a_pin")
    case .quickPinConfirmPin:
      bundle.localizedString(forKey: "quick_pin_confirm_pin")
    case .biometryConfirmRequest:
      bundle.localizedString(forKey: "biometry_confirm_request")
    case .viewDetails:
      bundle.localizedString(forKey: "view_details")
    case .requestsTheFollowing:
      bundle.localizedString(forKey: "requests_the_following")
    case .walletIsSecured:
      bundle.localizedString(forKey: "wallet_is_secured")
    case .noResults:
      bundle.localizedString(forKey: "no_results")
    case .noResultsDescription:
      bundle.localizedString(forKey: "no_results_description")
    case .proximityConnectionNfcDescription:
      bundle.localizedString(forKey: "proximity_connection_nfc_description")
    case .orShareViaNfc:
      bundle.localizedString(forKey: "")
    case .filters:
      bundle.localizedString(forKey: "filters")
    case .sortByIssuedDateSectionTitle:
      bundle.localizedString(forKey: "sort_by_issued_date")
    case .issuerSectionTitle:
      bundle.localizedString(forKey: "issuer")
    case .showResults:
      bundle.localizedString(forKey: "show_results")
    case .reset:
      bundle.localizedString(forKey: "reset")
    case .all:
      bundle.localizedString(forKey: "all")
    case .descending:
      bundle.localizedString(forKey: "desceding")
    case .ascending:
      bundle.localizedString(forKey: "asceding")
    case .expiryPeriodSectionTitle:
      bundle.localizedString(forKey: "expiry")
    case .selectExpiryPeriod:
      bundle.localizedString(forKey: "expiry_period")
    case .state:
      bundle.localizedString(forKey: "state")
    case .sortBy:
      bundle.localizedString(forKey: "sort_by")
    case .issuanceSuccessHeaderDescriptionWhenError:
      bundle.localizedString(forKey: "issuance_success_header_description_when_error")
    case .deleteDocumentConfirmDialog:
      bundle.localizedString(forKey: "delete_document_confirm_dialog")
    case .defaultLabel:
      bundle.localizedString(forKey: "default")
    case .valid:
      bundle.localizedString(forKey: "valid")
    case .revoke:
      bundle.localizedString(forKey: "revoke")
    case .expired:
      bundle.localizedString(forKey: "expired")
    case .dateIssued:
      bundle.localizedString(forKey: "date_issued")
    case .expiryDate:
      bundle.localizedString(forKey: "expiry_date")
    case .nextSevenDays:
      bundle.localizedString(forKey: "next_seven_days")
    case .nextThirtyDays:
      bundle.localizedString(forKey: "next_thirty_days")
    case .beyondThiryDays:
      bundle.localizedString(forKey: "beyond_thirty_days")
    case .beforeToday:
      bundle.localizedString(forKey: "before_today")
    case .issuanceRequest:
      bundle.localizedString(forKey: "issuance_request")
    case .myEuWallet:
      bundle.localizedString(forKey: "My EU Wallet")
    case .categoryGovernment:
      bundle.localizedString(forKey: "category_government")
    case .categoryHealth:
      bundle.localizedString(forKey: "category_health")
    case .categoryEducation:
      bundle.localizedString(forKey: "category_education")
    case .categoryFinance:
      bundle.localizedString(forKey: "category_finance")
    case .categoryRetail:
      bundle.localizedString(forKey: "category_retail")
    case .categoryOther:
      bundle.localizedString(forKey: "category_other")
    case .categorySocialSecurity:
      bundle.localizedString(forKey: "category_social_security")
    case .categoryTravel:
      bundle.localizedString(forKey: "category_travel")
    case .changelog:
      bundle.localizedString(forKey: "changelog")
    }
  }

  public func get(with key: Key) -> LocalizedStringKey {
    return self.get(with: key).toLocalizedStringKey
  }
}

public extension LocalizableString {
  enum Key: Equatable, Sendable {
    case dynamic(key: String)
    case custom(String)
    case space
    case search
    case genericErrorTitle
    case genericErrorDesc
    case biometryOpenSettings
    case biometryConfirmRequest
    case invalidQuickPin
    case tryAgain
    case shareButton
    case cancelButton
    case requestDataCaption
    case requestDataInfoNotice
    case requestDataTitle([String])
    case documentAdded
    case requestDataSheetCaption
    case okButton
    case shareDataReview
    case success
    case successfullySharedFollowingInformation
    case incompleteRequestDataSelection
    case addDoc
    case filters
    case sortByIssuedDateSectionTitle
    case issuerSectionTitle
    case showResults
    case showQRTap
    case welcomeBack([String])
    case viewDocumentDetails
    case pleaseWait
    case requestDataShareQuickPinCaption
    case requestDataShareBiometryCaption
    case addDocumentTitle
    case addDocumentSubtitle
    case addDocumentRequest
    case proximityConnectivityCaption
    case unavailableField
    case requestDataVerifiedEntity
    case requestDataVerifiedEntityMessage
    case moreOptions
    case changeQuickPinOption
    case quickPinSetTitle
    case quickPinEnterPin
    case quickPinConfirmPin
    case quickPinSetCaptionOne
    case quickPinSetCaptionTwo
    case quickPinNextButton
    case quickPinConfirmButton
    case quickPinSetSuccess
    case loginTitle
    case loginCaptionQuickPinOnly
    case loginCaption
    case quickPinSetSuccessButton
    case quickPinDoNotMatch
    case quickPinUpdateTitle
    case quickPinUpdateCaptionOne
    case quickPinUpdateCaptionTwo
    case quickPinUpdateCaptionThree
    case quickPinUpdateSuccess
    case quickPinUpdateSuccessButton
    case quickPinUpdateCancellationTitle
    case quickPinUpdateCancellationCaption
    case quickPinUpdateCancellationContinue
    case issuanceDetailsContinueButton
    case successTitlePunctuated
    case issuanceSuccessCaption([String])
    case issuanceSuccessNextButton
    case issuerWantWalletAddition
    case unknownVerifier
    case unknownIssuer
    case genericIssuer
    case issuer
    case yes
    case no
    case scanQrCode
    case signDocument
    case signDocumentSubtitle
    case selectDocument
    case validUntil([String])
    case bleDisabledModalTitle
    case bleDisabledModalCaption
    case bleDisabledModalButton
    case requestDataNoDocument
    case issuanceDetailsDeletionTitle([String])
    case deleteDocument
    case issuanceDetailsDeletionCaption([String])
    case errorUnableFetchDocuments
    case errorUnableFetchDocument
    case scannerQrTitleIssuing
    case scannerQrTitlePresentation
    case scannerQrCaptionIssuing
    case scannerQrCaptionPresentation
    case scannerQrTitle
    case scannerQrCaption
    case cameraError
    case missingPid
    case requestCredentialOfferTitle([String])
    case requestCredentialOfferCaption
    case requestCredentialOfferNoDocument
    case unableToIssueAndStore
    case issueButton
    case cancelIssueSheetTitle
    case cancelIssueSheetCaption
    case cancelIssueSheetContinue
    case credentialOfferSuccessButton
    case credentialOfferSuccessCaption([String])
    case credentialOfferPartialSuccessCaption([String])
    case issuanceCodeTitle([String])
    case issuanceCodeCaption([String])
    case transactionCodeFormatError([String])
    case inProgress
    case scopedIssuanceSuccessDeferredCaption
    case scopedIssuanceSuccessDeferredCaptionDocName([String])
    case scopedIssuanceSuccessDeferredCaptionDocNameAndIssuer([String])
    case issuanceSuccessDeferredCaption([String])
    case pending
    case issuanceFailed
    case deferredDocumentsIssuedModalTitle
    case defferedDocumentsIssuedModalCaption
    case retrieveLogs
    case qrScanInformativeText
    case unableToPresentAndShare
    case itemNotFoundInStorage
    case itemsNotFoundInStorage
    case home
    case documents
    case transactions
    case authenticateAuthoriseTransactions
    case electronicallySignDigitalDocuments
    case learnMore
    case chooseFromList
    case chooseFromListTitle
    case addDocumentsToWallet
    case details
    case dataSharingRequest
    case dataShared
    case doneButton
    case dataSharingTitle
    case close
    case reset
    case all
    case descending
    case ascending
    case issuanceSuccessHeaderDescriptionWhenError
    case trustedRelyingParty
    case trustedRelyingPartyDescription
    case alertAccessOnlineServices
    case alertAccessOnlineServicesMessage
    case alertSignDocumentsSafely
    case alertSignDocumentsSafelyMessage
    case authenticate
    case inPerson
    case online
    case fromDevice
    case autodashboardAuthenticateDialogMessage
    case deleteButton
    case savedToFavorites
    case succesfullyAddedFollowingToWallet
    case removedFromFavorites
    case savedToFavoritesMessage
    case removedFromFavoritesMessages
    case viewDetails
    case requestsTheFollowing
    case walletIsSecured
    case noResults
    case noResultsDescription
    case proximityConnectionNfcDescription
    case orShareViaNfc
    case expiryPeriodSectionTitle
    case selectExpiryPeriod
    case state
    case sortBy
    case deleteDocumentConfirmDialog
    case defaultLabel
    case valid
    case revoke
    case expired
    case dateIssued
    case expiryDate
    case nextSevenDays
    case nextThirtyDays
    case beyondThiryDays
    case beforeToday
    case issuanceRequest
    case myEuWallet
    case categoryGovernment
    case categoryHealth
    case categoryEducation
    case categoryFinance
    case categoryRetail
    case categoryOther
    case categorySocialSecurity
    case categoryTravel
    case changelog
  }
}

fileprivate extension String {
  var toLocalizedStringKey: LocalizedStringKey {
    LocalizedStringKey(self)
  }
}

fileprivate extension Bundle {
  func localizedString(forKey key: String) -> String {
    self.localizedString(forKey: key, value: nil, table: nil)
  }
  func localizedStringWithArguments(forKey key: String, arguments: [CVarArg]) -> String {
    String(format: self.localizedString(forKey: key), locale: nil, arguments: arguments)
  }
}
