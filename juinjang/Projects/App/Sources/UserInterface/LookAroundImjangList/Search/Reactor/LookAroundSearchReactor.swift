//
//  LookAroundSearchReactor.swift
//  juinjang
//
//  Created by 조유진 on 3/25/25.
//

import ReactorKit

final class LookAroundSearchReactor: Reactor {
    var initialState = State()
    
    enum Action {
        case viewDidLoad
        case searchSummitButtonTapped(keyword: String)
        case removeAllKeywordTapped
        case delteKeywordButtonTapped(index: Int)
    }
    
    enum Mutation {
        case setRecentSearchKeywordList([String])
    }
    
    struct State {
        var recentSearchKeywordList: [String] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let list = getRecentSearchList()
            return .just(.setRecentSearchKeywordList(list))
            
        case .searchSummitButtonTapped(let keyword):
            saveSearchText(keyword)
            let list = getRecentSearchList()
            return .just(.setRecentSearchKeywordList(list))
            
        case .removeAllKeywordTapped:
            removeAllSearchKeyword()
            let list = getRecentSearchList()
            return .just(.setRecentSearchKeywordList(list))
            
        case .delteKeywordButtonTapped(let index):
            print("deleteKeywordButtonTapped")
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRecentSearchKeywordList(let list):
            newState.recentSearchKeywordList = list
        }
        return newState
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
        print(#function)
        UserDefaultManager.shared.clearKey(UserDefaultManager.UDKey.lookAroundSearchKeywords.rawValue)
    }
    
    private func getRecentSearchList() -> [String] {
        print(#function, UserDefaultManager.shared.lookAroundSearchKeywords)
        return UserDefaultManager.shared.lookAroundSearchKeywords
    }
}
