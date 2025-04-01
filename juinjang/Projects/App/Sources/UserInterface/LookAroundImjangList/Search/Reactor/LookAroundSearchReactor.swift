//
//  LookAroundSearchReactor.swift
//  juinjang
//
//  Created by 조유진 on 3/25/25.
//

import ReactorKit
import UIKit

final class LookAroundSearchReactor: Reactor {
    var initialState = State()
    
    struct Dependency {
        let lookAroundRepository: LookAroundRepository
    }

    let dependency: Dependency

    init(dependency: Dependency) {
      self.dependency = dependency
    }
    
    enum Action {
        case viewDidLoad
        case searchSummitButtonTapped(keyword: String)
        case searchKeywordTapped(keyword: String)
        case removeAllKeywordTapped
        case deleteKeywordButtonTapped(keyword: String)
    }
    
    enum Mutation {
        case setRecentSearchKeywordList([String])
        case setSearchResultList(LookAroundImjangResult)
    }
    
    struct State {
        var recentSearchKeywordList: [String] = []
        var searchResultList: [LookAroundSearchResultSectionModel] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let list = getRecentSearchList()
            return .just(.setRecentSearchKeywordList(list))
            
        case .searchSummitButtonTapped(let keyword):
            saveSearchText(keyword)
            let searchKeywordlist = getRecentSearchList()
            return .concat([
                .just(.setRecentSearchKeywordList(searchKeywordlist)),
                dependency.lookAroundRepository.fetchLookAroundImjang(keyword: keyword)
                    .map {
                        Mutation.setSearchResultList($0)
                    }
            ])
            
        case .searchKeywordTapped(let keyword):
            saveSearchText(keyword)
            let searchKeywordlist = getRecentSearchList()
            return .concat([
                .just(.setRecentSearchKeywordList(searchKeywordlist)),
                dependency.lookAroundRepository.fetchLookAroundImjang(keyword: keyword)
                    .map {
                        Mutation.setSearchResultList($0)
                    }
            ])
            
        case .removeAllKeywordTapped:
            removeAllSearchKeyword()
            let list = getRecentSearchList()
            return .just(.setRecentSearchKeywordList(list))
            
        case .deleteKeywordButtonTapped(let keyword):
            deleteSearchKeyword(keyword)
            let list = getRecentSearchList()
            return .just(.setRecentSearchKeywordList(list))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRecentSearchKeywordList(let list):
            newState.recentSearchKeywordList = list
        case .setSearchResultList(let list):
            let list = getSectionLookAroundImjangDataList(list)
            newState.searchResultList = list
        }
        return newState
    }
    
    private func getSectionLookAroundImjangDataList(_ lookAroundImjangResult: LookAroundImjangResult) -> [LookAroundSearchResultSectionModel] {
        let imjangListSectionList = lookAroundImjangResult.notes.map {
            LookAroundSearchResultSectionModel.Row.imjangListSection(lookAroundImjang: $0)
        }

        let sectionOfLookAroundImjangData: [LookAroundSearchResultSectionModel] = [
            .imjangCountSection(items: [.imjangCountSection(imjangCount: lookAroundImjangResult.totalResults)]),
            .imjangListSection(header: "", items: imjangListSectionList)
        ]
        return sectionOfLookAroundImjangData
    }
    
    private func saveSearchText(_ keyword: String) {
        var keywordArray = UserDefaultManager.shared.lookAroundSearchKeywords
        
        if let index = keywordArray.firstIndex(where: { $0 == keyword }) {
            keywordArray.remove(at: index)
            keywordArray.insert(keyword, at: 0)
        } else {
            if keywordArray.count < 5 {
                keywordArray.insert(keyword, at: 0)
            } else {
                keywordArray.removeLast()
                keywordArray.insert(keyword, at: 0)
            }
        }
        
        UserDefaultManager.shared.lookAroundSearchKeywords = keywordArray
    }
    
    private func removeAllSearchKeyword() {
        UserDefaultManager.shared.clearKey(UserDefaultManager.UDKey.lookAroundSearchKeywords.rawValue)
    }
    
    private func deleteSearchKeyword(_ keyword: String) {
        var keywordArray = UserDefaultManager.shared.lookAroundSearchKeywords
        if let index = keywordArray.firstIndex(where: { $0 == keyword }) {
            keywordArray.remove(at: index)
            UserDefaultManager.shared.lookAroundSearchKeywords = keywordArray
        }
    }
    
    private func getRecentSearchList() -> [String] {
        return UserDefaultManager.shared.lookAroundSearchKeywords
    }
}

struct LookAroundImjangResult: Decodable {
    let totalResults: Int
    let notes: [LookAroundImjangNote]
}

struct LookAroundImjangNote: Decodable, Hashable {
    let sharedNoteId: Int
    let buildingName: String
    let propertyType: String
    let imageUrl: String
    let isPurchase: Bool
    let isLiked: Bool
    let rate: Double
    let type: String
    let price: String
    let pyong: Int
    let floor: String
    let address: String
    let ownerImageUrl: String
    let ownerNickname: String
    let monthAge: Int
    let viewCount: Int
}


enum PropertyType: String, CaseIterable {
    case APARTMENT
    case VILLA
    case OFFICE_TEL
    case DETACHED_HOUSE

    var image: UIImage {
        switch self {
        case .APARTMENT: return .ImjangList.apartment
        case .VILLA: return .ImjangList.villa
        case .OFFICE_TEL: return .ImjangList.officeTel
        case .DETACHED_HOUSE: return .ImjangList.detachedHouse
        }
    }
}
