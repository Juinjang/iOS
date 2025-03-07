//
//  ShareImjangNoteReactor.swift
//  juinjang
//
//  Created by 강동영 on 3/7/25.
//

import Foundation
import ReactorKit

class ShareImjangNoteReactor: Reactor {
    enum Action {
        case none
    }
    
    enum Mutation {
        case none
    }
    
    struct State {
        
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Action> {
        .just(.none)
    }
    
    func reduce(state: State, mutation: Action) -> State {
        return state
    }
}
