//
//  SelectAreaReactor.swift
//  juinjang
//
//  Created by 조유진 on 5/5/25.
//

import ReactorKit
import Foundation

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
        case setErrorMessage(String?)
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
        newState.errorMessage = nil
        switch mutation {
        case .setSidoList(let sectionList):
            newState.sidoList = sectionList
        case .setSigunguList(let sectionList):
            newState.sigunguList = sectionList
        case .setDongList(let dongList):
            newState.dongList = dongList
        case .setSelectedAreaList(let areaList):
            newState.selectedAreaList = areaList
        case .setErrorMessage(let errorMessage):
            newState.errorMessage = errorMessage
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
                    fetchSigunguList(admCode: admResponseDto.admVOList.admVOList[0].admCode),
                ])
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
                
                return setDongList(list: list)
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
        
        dongList.enumerated().forEach { index, item in
            guard index == selectedIndex else { return }
            
            let newSelectedAreaList = selected(item: item)
            
            selectedAreaList = newSelectedAreaList
        }
        
        let newDongList = dongList.map { item in
            let isSelected = selectedAreaList.map{ $0.admCode }.contains(item.admCode)
            return DongCellItem(
                admCode: item.admCode,
                name: item.name,
                isSelected: isSelected,
                isTotal: item.isTotal
            )
        }
        
        guard selectedAreaList.count <= 3 else {
            return .just(.setErrorMessage(SelectAreaError.limitCount.errorDescription))
        }
        
        sectionModel.dongItemList = newDongList
        return .concat([
            .just(.setDongList([sectionModel])),
            .just(.setSelectedAreaList(selectedAreaList))
        ])
    }
    
    private func selected(item: DongCellItem) -> [DongCellItem] {
        var selectedAreaList = currentState.selectedAreaList
        
        if selectedAreaList.isEmpty {
            selectedAreaList.append(item)
            return selectedAreaList
        }
        
        if item.isSelected {
            if let index = selectedAreaList.firstIndex(where: { $0.admCode == item.admCode }) {
                selectedAreaList.remove(at: index)
            }
            return selectedAreaList
        }
        
        if item.isTotal {   // 시군구 전체 클릭 시
            for selectedArea in selectedAreaList {
                if selectedArea.admCode.contains(item.admCode) {
                    if let removeIndex = selectedAreaList.firstIndex(where: { $0.admCode.contains(item.admCode) }) {
                        selectedAreaList.remove(at: removeIndex)
                    }
                }
            }
            selectedAreaList.append(item)
            return selectedAreaList
        } else {
            let totalAdmCode = String(item.admCode.prefix(5))
            for (index, selectedArea) in selectedAreaList.enumerated() {
                if selectedArea.admCode.contains(totalAdmCode) && selectedArea.isTotal {
                    selectedAreaList.remove(at: index)
                }
            }
            selectedAreaList.append(item)
            return selectedAreaList
        }
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
            
            if admVO.lowestAdmCodeNm == "세종특별자치시" {
                return SigunguCellItem(admCode: admVO.admCode, name: "세종시")
            }
            return SigunguCellItem(admCode: admVO.admCode, name: admVO.lowestAdmCodeNm)
        }
        
        let sectionModel = [SigunguSectionModel(section: .main, sigunguItemList: sidoCellItems)]
        return .just(.setSigunguList(sectionModel))
    }
    
    private func setDongList(list: [AdmVO]) -> Observable<Mutation> {
        let dongCellItems = list.enumerated().map { index, admVO in
            DongCellItem(
                admCode: admVO.admCode,
                name: admVO.lowestAdmCodeNm,
                isSelected: isSelectedArea(admCode: admVO.admCode),
                isTotal: index == 0
            )
        }
        
        let sectionModel = [DongSectionModel(section: .main, dongItemList: dongCellItems)]
        return .just(.setDongList(sectionModel))
    }
    
    private func isSelectedArea(admCode: String) -> Bool {
        let selectedAreaList = currentState.selectedAreaList
        return selectedAreaList.contains(where: { $0.admCode == admCode })
    }
}

enum SelectAreaError: LocalizedError {
    case limitCount
    
    var errorDescription: String? {
        switch self {
        case .limitCount: "지역 선택은 3개까지 가능해요"
        }
    }
}
