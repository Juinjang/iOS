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
        case sigunguSelected(Int)
        case dongSelected(Int)
        case resetButtonTapped
    }
    
    enum Mutation {
        case setSidoList([SidoSectionModel])
        case setSigunguList([SigunguSectionModel])
        case setDongList([DongSectionModel])
        case setSelectedAreaList([DongCellItem])
        case setError(Error)
    }
    
    struct State {
        var sidoList: [SidoSectionModel] = []
        var sigunguList: [SigunguSectionModel] = []
        var dongList: [DongSectionModel] = []
        var selectedAreaList: [DongCellItem] = []
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
            guard currentState.sidoList.isEmpty else { return .empty() }
            return fetchInitialSidoList()
        case .sidoSelected(let index):
            return selectSido(selectedIndex: index)
        case .sigunguSelected(let index):
            return selectSigungu(selectedIndex: index)
        case .dongSelected(let index):
            return selectDong(selectedIndex: index)
        case .resetButtonTapped:
            return .concat([
                selectSido(selectedIndex: 0, isReset: true),
                .just(.setSelectedAreaList([]))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSidoList(let sectionList):
            newState.sidoList = sectionList
        case .setSigunguList(let sectionList):
            newState.sigunguList = sectionList
        case .setDongList(let dongList):
            newState.dongList = dongList
        case .setSelectedAreaList(let areaList):
            newState.selectedAreaList = areaList
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
                dump(list)
                return setSigunguList(list: list)
            }
            .catch { error in
                return Observable.just(.setError(error))
            }
    }
    
    // 선택된 시군구 기준 동읍면 조회
    private func fetchDongList(signugu: SigunguCellItem?) -> Observable<Mutation> {
        guard let signugu else { return .empty() }
        let admRequestDto = AreaCodeRequestDTO(admCode: signugu.admCode)
        
        return dependency.selectAreaRepository
            .fetchAdmDongList(param: admRequestDto)
            .asObservable()
            .flatMap { [weak self] admResponseDto -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                var list = admResponseDto.admVOList.admVOList

                let totalDong = AdmVO(admCode: signugu.admCode, lowestAdmCodeNm: "\(signugu.name) 전체")
                list.insert(totalDong, at: 0)
                
                dump(list)
                return setDongList(list: list)
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
    private func selectSido(selectedIndex: Int, isReset: Bool = false) -> Observable<Mutation> {
        guard let sectionModel = currentState.sidoList.first else { return .empty() }
        
        if !isReset {
            guard !sectionModel.sidoItemList.isEmpty,
                  sectionModel.selectedIndex != selectedIndex else { return .empty() }
        }
        let sidoList = sectionModel.sidoItemList
        
        let newSidoList = sidoList.enumerated().map { index, item in
            SidoCellItem(
                admCode: item.admCode,
                name: item.name,
                isSelected: index == selectedIndex
                ? true : false
            )
        }
        let newSectionModel = [SidoSectionModel(section: .main, sidoItemList: newSidoList, selectedIndex: selectedIndex)]
        return .concat([
            .just(.setSidoList(newSectionModel)),
            .just(.setDongList([])),
            fetchSigunguList(admCode: sidoAdmCode(index: selectedIndex))
        ])
    }
    
    // 시도 admCode
    private func sidoAdmCode(index: Int) -> String? {
        guard let list = currentState.sidoList.first?.sidoItemList else { return nil }
        guard list.count > index else { return nil }
        return list[index].admCode
    }
    
    // 시군구 admCode
    private func sigungu(index: Int) -> SigunguCellItem? {
        guard let list = currentState.sigunguList.first?.sigunguItemList else { return nil }
        guard list.count > index else { return nil }
        return list[index]
    }
    
    // 시군구 선택 -> 시군구 UI 업데이트, 동 조회
    private func selectSigungu(selectedIndex: Int) -> Observable<Mutation> {
        guard let sectionModel = currentState.sigunguList.first else { return .empty() }
        guard !sectionModel.sigunguItemList.isEmpty,
                sectionModel.selectedIndex != selectedIndex else { return .empty() }
        let sigunguList = sectionModel.sigunguItemList
        
        let selectedSigungu: SigunguCellItem
        let newSigunguList = sigunguList.enumerated().map { index, item in
            SigunguCellItem(
                admCode: item.admCode,
                name: item.name,
                isSelected: index == selectedIndex
                ? true : false
            )
        }
        let newSectionModel = [SigunguSectionModel(section: .main, sigunguItemList: newSigunguList, selectedIndex: selectedIndex)]
        return .concat([
            .just(.setSigunguList(newSectionModel)),
            fetchDongList(signugu: sigungu(index: selectedIndex))
        ])
    }
    
    // 동 선택
    private func selectDong(selectedIndex: Int) -> Observable<Mutation> {
        guard var sectionModel = currentState.dongList.first else { return .empty() }
        guard sectionModel.dongItemList.count > selectedIndex else { return .empty() }
        var selectedAreaList = currentState.selectedAreaList
        let dongList = sectionModel.dongItemList
        
        let newDongList = dongList.enumerated().map { index, item in
            guard index == selectedIndex else { return item }
            
            var isSelected: Bool
            
            if item.isSelected {
                isSelected = false
                selectedAreaList.removeAll { $0.admCode == item.admCode }
            } else {
                isSelected = true
                selectedAreaList.append(item)
            }
            
            return DongCellItem(
                admCode: item.admCode,
                name: item.name,
                isSelected: isSelected
            )
        }
        sectionModel.dongItemList = newDongList
        return .concat([
            .just(.setDongList([sectionModel])),
            .just(.setSelectedAreaList(selectedAreaList))
        ])
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
    
    private func setDongList(list: [AdmVO]) -> Observable<Mutation> {
        let dongCellItems = list.enumerated().map { index, admVO in
            DongCellItem(admCode: admVO.admCode, name: admVO.lowestAdmCodeNm, isTotal: index == 0)
        }
        
        let sectionModel = [DongSectionModel(section: .main, dongItemList: dongCellItems)]
        return .just(.setDongList(sectionModel))
    }
}
