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
import logic_core
import logic_business
import logic_resources
import Combine

public enum DashboardPartialState: Sendable {
  case success(String, FilterableList, Bool)
  case failure(Error)
}

public enum DashboardDeleteDeferredPartialState: Sendable {
  case success
  case noDocuments
  case failure(Error)
}

public enum FiltersPartialState: Sendable {
  case filterResult([DocumentUIModel], [FilterUISection])
  case cancelled
}

public enum DashboardDeferredPartialState: Sendable {
  case completion(issued: [DocumentUIModel], failed: [String])
  case cancelled
}

public protocol DashboardInteractor: Sendable {
  func fetchDashboard(failedDocuments: [String]) async -> DashboardPartialState
  func getBleAvailability() async -> Reachability.BleAvailibity
  @MainActor func openBleSettings()
  func getAppVersion() -> String
  func hasIssuedDocuments() -> Bool
  func hasDeferredDocuments() -> Bool
  func deleteDeferredDocument(with id: String) async -> DashboardDeleteDeferredPartialState
  func requestDeferredIssuance() async -> DashboardDeferredPartialState
  func retrieveLogFileUrl() -> URL?
  @MainActor func onFilterChangeState() -> AsyncStream<FiltersPartialState>
  func initializeFilters(filters: Filters, filterableList: FilterableList) async
  func applyFilters() async
  func resetFilters() async
  func updateFilters(sectionID: String, filterID: String) async
  func fetchFilteredDocuments(failedDocuments: [String]) -> FilterableList?
  func updateFilterList(filterableList: FilterableList, filters: Filters) async
  func updateSortOrder(sortOrder: SortOrderType)
  func createFiltersGroup() -> Filters
  func addDynamicFilters(documents: FilterableList, filters: Filters) async -> Filters
}

final class DashboardInteractorImpl: DashboardInteractor {

  private let walletController: WalletKitController
  private let filterValidator: FilterValidator
  private let reachabilityController: ReachabilityController
  private let configLogic: ConfigLogic

  private let sendableAnyCancellable: SendableAnyCancellable = .init()

  @MainActor
  private var filtersStateAsync: AsyncStream<FiltersPartialState>.Continuation?

  init(
    walletController: WalletKitController,
    filterValidator: FilterValidator,
    reachabilityController: ReachabilityController,
    configLogic: ConfigLogic
  ) {
    self.walletController = walletController
    self.filterValidator = filterValidator
    self.reachabilityController = reachabilityController
    self.configLogic = configLogic
  }

  deinit {
    sendableAnyCancellable.cancel()
    filtersStateAsync?.finish()
  }

  func hasIssuedDocuments() -> Bool {
    return !walletController.fetchIssuedDocuments().isEmpty
  }

  func hasDeferredDocuments() -> Bool {
    return !walletController.fetchDeferredDocuments().isEmpty
  }

  func onFilterChangeState() -> AsyncStream<FiltersPartialState> {
    return AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
      self.filtersStateAsync = continuation
      Task {
        for try await state in filterValidator.getFilterResultStream() {
          switch state {
          case .success(let filterResult):
            let documentsUI = filterResult.filteredList.items.compactMap { filterableItem in
              return filterableItem.payload as? DocumentUIModel
            }

            let filterSections = filterResult.updatedFilters.filterGroups.map { filteredGroup in
              FilterUISection(
                id: filteredGroup.id,
                filters: filteredGroup.filters.map { filter in
                  FilterUIItem(
                    id: filter.id,
                    title: filter.name,
                    selected: filter.selected,
                    filterAction: filter.filterableAction
                  )
                },
                sectionTitle: filteredGroup.name
              )
            }

            continuation.yield(.filterResult(documentsUI, filterSections))
          case .completion:
            continuation.yield(.cancelled)
            continuation.finish()
          }
        }
      }
    }
  }

  func createFiltersGroup() -> Filters {
    return Filters(
      filterGroups: [
        FilterGroup(
          name: LocalizableString.shared.get(with: .sortByIssuedDateSectionTitle),
          filters: [
            FilterItem(
              name: LocalizableString.shared.get(with: .ascending),
              selected: false,
              filterableAction: Sort<DocumentFilterableAttributes, String>(predicate: { attribute in
                return attribute.name
              })
            ),
            FilterItem(
              name: LocalizableString.shared.get(with: .descending),
              selected: false,
              filterableAction: Sort<DocumentFilterableAttributes, String>(predicate: { attribute in
                return attribute.name
              })
            )
          ],
          filterType: .other
        ),
        FilterGroup(
          name: LocalizableString.shared.get(with: .sortBy),
          filters: [
            FilterItem(
              name: LocalizableString.shared.get(with: .defaultLabel),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { _, _ in
                return false
              })
            ),
            FilterItem(
              name: LocalizableString.shared.get(with: .dateIssued),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { _, _ in
                return false
              })
            ),
            FilterItem(
              name: LocalizableString.shared.get(with: .expiryDate),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { _, _ in
                return false
              })
            )
          ],
          filterType: .other
        ),
        FilterGroup(
          name: LocalizableString.shared.get(with: .expiryPeriodSectionTitle),
          filters: [
            FilterItem(
              name: LocalizableString.shared.get(with: .nextSevenDays),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isWithinNextDays(7)
              })
            ),
            FilterItem(
              name: LocalizableString.shared.get(with: .nextThirtyDays),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isWithinNextDays(30)
              })
            ),
            FilterItem(
              name: LocalizableString.shared.get(with: .beyondThiryDays),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isBeyondNextDays(30)
              })
            ),
            FilterItem(
              name: LocalizableString.shared.get(with: .beforeToday),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isBeforeToday()
              })
            )
          ],
          filterType: .other
        ),
        FilterGroup(
          name: LocalizableString.shared.get(with: .state),
          filters: [
            FilterItem(
              name: LocalizableString.shared.get(with: .defaultLabel),
              selected: true,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { _, _ in
                true
              })
            ),
            FilterItem(
              name: LocalizableString.shared.get(with: .valid),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                attributes.expiryDate?.isBeforeToday() == false
              })
            ),
            FilterItem(
              name: LocalizableString.shared.get(with: .expired),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                attributes.expiryDate?.isBeforeToday() == true
              })
            )
          ],
          filterType: .other
        ),
        FilterGroup(
          name: LocalizableString.shared.get(with: .issuer),
          filters: [],
          filterType: .issuer
        )
      ],
      sortOrder: SortOrderType.ascending
    )
  }

  func addDynamicFilters(documents: FilterableList, filters: Filters) async -> Filters {
    let newFilterGroups = filters.filterGroups.map { filterGroup in
      switch filterGroup.filterType {
        case .issuer:
          return filterGroup.copy(
            filters: addIssuerFilter(documents: documents)
          )
        default:
          return filterGroup
      }
    }

    return filters.copy(filterGroups: newFilterGroups)
  }

  private func addIssuerFilter(documents: FilterableList) -> [FilterItem] {
    let distinctIssuers = documents.items.compactMap {
      ($0.attributes as? DocumentFilterableAttributes)?.issuer
    }.reduce(into: [String]()) { unique, element in
      if !unique.contains(element) {
        unique.append(element)
      }
    }

    var filterItems = distinctIssuers.map { issuer in
      return FilterItem(
        id: UUID(),
        name: issuer,
        selected: false,
        filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, filter in
          attributes.name == filter.name
        })
      )
    }

    filterItems.insert(
      FilterItem(
        id: UUID(),
        name: "All",
        selected: true,
        filterableAction: Filter<DocumentFilterableAttributes>(predicate: { _, _ in true })
      ),
      at: 0
    )

    return filterItems
  }

  func initializeFilters(filters: Filters, filterableList: FilterableList) async {
    await filterValidator.initializeFilters(filters: filters, filterableList: filterableList)
  }

  func applyFilters() async {
    await filterValidator.applyFilters()
  }

  func resetFilters() async {
    await filterValidator.resetFilters()
  }

  func updateFilters(sectionID: String, filterID: String)  async {
    await filterValidator.updateFilter(filterGroupId: sectionID, filterId: filterID)
  }

  func updateFilterList(filterableList: FilterableList, filters: Filters) async {
    await filterValidator.updateFilterList(filterableList: filterableList, filters: filters)
  }

  func updateSortOrder(sortOrder: SortOrderType) {
    Task {
      await filterValidator.updateSortOrder(sortOrder: sortOrder)
    }
  }

  func fetchDashboard(failedDocuments: [String]) async -> DashboardPartialState {

    let documents: FilterableList? = fetchFilteredDocuments(failedDocuments: failedDocuments)
    let username = fetchUsername()

    guard let documents = documents else {
      return .failure(WalletCoreError.unableFetchDocuments)
    }

    return .success(username, documents, hasIssuedDocuments())
  }

  func getBleAvailability() async -> Reachability.BleAvailibity {
    return await withCheckedContinuation { cont in
      reachabilityController.getBleAvailibity()
        .sink { cont.resume(returning: $0)}
        .store(in: &sendableAnyCancellable.cancellables)
    }
  }

  func openBleSettings() {
    reachabilityController.openBleSettings()
  }

  func getAppVersion() -> String {
    return configLogic.appVersion
  }

  func deleteDeferredDocument(with id: String) async -> DashboardDeleteDeferredPartialState {
    do {
      try await walletController.deleteDocument(with: id, status: .deferred)
      return walletController.fetchAllDocuments().isEmpty ? .noDocuments : .success
    } catch {
      return .failure(error)
    }
  }

  func requestDeferredIssuance() async -> DashboardDeferredPartialState {

    var issued: [DocumentUIModel] = []
    var failed: [String] = []

    let categories = self.walletController.getDocumentCategories()

    for deferred in walletController.fetchDeferredDocuments() {

      if Task.isCancelled { return .cancelled }

      do {
        let document = try await walletController.requestDeferredIssuance(with: deferred)
        if (document is DeferrredDocument) == false {
          issued.append(document.transformToDocumentUi(categories: categories))
        }
      } catch {
        failed.append(deferred.id)
      }
    }

    return .completion(issued: issued, failed: failed)
  }

  func retrieveLogFileUrl() -> URL? {
    return walletController.retrieveLogFileUrl()
  }

  public func fetchFilteredDocuments(failedDocuments: [String]) -> FilterableList? {
    let documents = self.walletController.fetchAllDocuments()

    guard !documents.isEmpty else {
      return nil
    }

    let filterableItems = documents.map { document in
      FilterableItem(
        payload: document.transformToDocumentUi(categories: self.walletController.getDocumentCategories()),
        attributes: DocumentFilterableAttributes(
          searchText: document.displayName ?? "",
          issuedDate: document.createdAt,
          expiryDate: document.validUntil,
          issuer: document.issuerName,
          name: document.displayName
        )
      )
    }

    return FilterableList(items: filterableItems)
  }

  private func fetchUsername() -> String {
    let name = walletController.fetchMainPidDocument()?.getBearersName()?.first
    return name.orEmpty
  }
}
