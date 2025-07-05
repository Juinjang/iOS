//
//  SelectAreaReactor.swift
//  juinjang
//
//  Created by 조유진 on 5/5/25.
//

import ReactorKit

final class SelectAreaReactor: Reactor {
    var initialState = State()
    
    enum Action {
        case viewDidLoad
        case sidoSelected(Int)
    }
    
    enum Mutation {
        case setSidoList([SidoSectionModel])
        case setSigunguList([SigunguSectionModel])
        case setError(Error)
    }
    
    struct State {
        var sidoList: [SidoSectionModel] = []
        var sigunguList: [SigunguSectionModel] = []
        var errorMessage: String?
    }
    
    struct Dependency {
        let selectAreaRepository: SelectAreaRepositoryProtocol
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchInitialSidoList()
        case .sidoSelected(let index):
            return selectSido(selectedIndex: index)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSidoList(let sectionList):
            newState.sidoList = sectionList
        case .setSigunguList(let sectionList):
            newState.sigunguList = sectionList
        case .setError(let error):
            newState.errorMessage = error.localizedDescription
        }
        return newState
    }
}

extension SelectAreaReactor{
    // 화면 진입 시 시도 조회 및 서울 선택
    private func fetchInitialSidoList() -> Observable<Mutation> {
        let admRequestDto = AreaCodeRequestDTO()
        return dependency.selectAreaRepository
            .fetchAdmSidoList(param: admRequestDto)
            .asObservable()
            .flatMap { [weak self] admResponseDto -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                return .concat([
                    selectInitialSido(list: admResponseDto.admVOList.admVOList),
                    fetchSigunguList(admCode: admResponseDto.admVOList.admVOList[0].admCode)
                ])
            }
            .catch { error in
                return Observable.just(.setError(error))
            }
    }
    
    // 선택된 시도 기준 시군구 조회
    private func fetchSigunguList(admCode: String?) -> Observable<Mutation> {
        guard let admCode else { return .empty() }
        let admRequestDto = AreaCodeRequestDTO(admCode: admCode)
        
        return dependency.selectAreaRepository
            .fetchAdmSigunguList(param: admRequestDto)
            .asObservable()
            .flatMap { [weak self] admResponseDto -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                let list = admResponseDto.admVOList.admVOList
                return setSigunguList(list: list)
            }
            .catch { error in
                return Observable.just(.setError(error))
            }
    }
    
    // 초기 시도 조회 시 서울 선택
    private func selectInitialSido(list: [AdmVO]) -> Observable<Mutation> {
        let sidoCellItems = list.enumerated().map { index, admVO in
            SidoCellItem(
                admCode: admVO.admCode,
                name: admVO.lowestAdmCodeNm,
                isSelected: index == 0 ? true : false
            )
        }
        let sectionModel = [SidoSectionModel(section: .main, sidoItemList: sidoCellItems)]
        return .just(.setSidoList(sectionModel))
    }
    
    // 시도 선택 -> 시도 UI 업데이트, 시군구 갱신
    private func selectSido(selectedIndex: Int) -> Observable<Mutation> {
        guard let sidoList = currentState.sidoList.first?.sidoItemList else { return .empty() }
        let newSidoList = sidoList.enumerated().map { index, item in
            SidoCellItem(
                admCode: item.admCode,
                name: item.name,
                isSelected: index == selectedIndex
                ? true : false
            )
        }
        let sectionModel = [SidoSectionModel(section: .main, sidoItemList: newSidoList)]
        return .concat([
            .just(.setSidoList(sectionModel)),
            fetchSigunguList(admCode: sidoAdmCode(index: selectedIndex))
        ])
    }
    
    // 시도 admCode
    private func sidoAdmCode(index: Int) -> String? {
        guard let list = currentState.sidoList.first?.sidoItemList else { return nil }
        guard list.count > index else { return nil }
        return list[index].admCode
    }
    
    private func setSidoList(list: [AdmVO]) -> Observable<Mutation> {
        let sidoCellItems = list.map { admVO in
            SidoCellItem(
                admCode: admVO.admCode,
                name: admVO.lowestAdmCodeNm
            )
        }
        let sectionModel = [SidoSectionModel(section: .main, sidoItemList: sidoCellItems)]
        return .just(.setSidoList(sectionModel))
    }
    
    private func setSigunguList(list: [AdmVO]) -> Observable<Mutation> {
        let sidoCellItems = list.map { admVO in
            SigunguCellItem(admCode: admVO.admCode, name: admVO.lowestAdmCodeNm)
        }
        
        let sectionModel = [SigunguSectionModel(section: .main, sigunguItemList: sidoCellItems)]
        return .just(.setSigunguList(sectionModel))
    }
}
