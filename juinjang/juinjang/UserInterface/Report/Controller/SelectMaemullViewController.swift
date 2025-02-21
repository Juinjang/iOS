//
//  SelectMaemullViewController.swift
//  juinjang
//
//  Created by 박도연 on 1/31/24.
//
import UIKit
import Then
import SnapKit
import Alamofire

protocol SendCompareImjangData{
    func sendData(isSelected: Bool, compareImjangId: Int,  compareImjangName: String)
}

final class SelectMaemullViewController : BaseViewController {
    
    var delegate: SendCompareImjangData?
    var scoreStates: [UIButton: Bool] = [:]
    
    var contentView = UIView().then {
        $0.backgroundColor = .mainWhite
    }
    
    lazy var filterselectBtn: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        configuration.attributedTitle = AttributedString(filterList[0].title, attributes: container)
        configuration.baseBackgroundColor = .mainWhite
        configuration.baseForegroundColor = .gray450
        configuration.image = ImageStyle.arrowDown
        configuration.image?.withTintColor(.gray450)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        let button = UIButton(configuration: configuration, primaryAction: nil)
        return button
    }()
    
    var menuChildren: [UIMenuElement] = []
    lazy var filterList = Filter.allCases
    var imjangList: [ListDto] = []
    var imjangId: Int
    var comparedImjangId : Int = 0
    var comparedName : String = ""
    
    let tableView = UITableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .mainWhite
        $0.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0)
        $0.register(ReportImjangListTableViewCell.self, forCellReuseIdentifier: ReportImjangListTableViewCell.identifier)
    }
    
    var btnBackGroundView = UIView().then{
        $0.backgroundColor = .mainWhite
    }
    
    var applyBtn = UIButton().then{
        $0.backgroundColor = .null
        $0.layer.cornerRadius = 10
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(.mainWhite, for: .normal)
        
    }
    
    func setFilterData() {
        for filter in filterList {
            menuChildren.append(UIAction(title: filter.title, state: .off,handler: { [weak self] (action: UIAction) in
                guard let self else { return }
                self.changefilterTitle(filter.title)
//                NotificationCenter.default.post(name: .imjangListFilterTapped, object: nil, userInfo: ["title":filter.title])
                callRequest(sort: filter, excludingId: imjangId)
            }))
        }
        if #available(iOS 17.0, *) {
            filterselectBtn.menu = UIMenu(options: .displayAsPalette, preferredElementSize: .small ,children: menuChildren)
        } else if #available(iOS 16.0, *){
            filterselectBtn.menu = UIMenu(options: .displayInline, preferredElementSize: .small ,children: menuChildren)
        } else {
            filterselectBtn.menu = UIMenu(options: .destructive, children: menuChildren)
        }
        
        
        filterselectBtn.showsMenuAsPrimaryAction = true
    }
    
    func changefilterTitle(_ title: String) {
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        filterselectBtn.configuration?.title = title
        filterselectBtn.configuration?.attributedTitle = AttributedString(title, attributes: container)
    }
    
    func callRequest(sort: Filter = .update, setScrap: Bool = false, excludingId: Int? = nil) {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .totalImjang(sort: sort.sortValue)) { response, error in
            if error == nil {
                guard let response = response else { return }
                guard let result = response.result else { return }
                
                let filteredList = result.limjangList.filter { item in
                    if let excludingId = excludingId {
                        return item.limjangId != excludingId
                    }
                    return true
                }
                
                self.imjangList = filteredList
                self.setEmptyUI(isEmpty: self.imjangList.isEmpty)
                self.tableView.reloadData()
            } else {
                guard let error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
    
    func setEmptyUI(isEmpty: Bool) {
        //emptyBackgroundView.isHidden = isEmpty ? false : true
        tableView.isHidden = isEmpty ? true : false
    }
    
    func setConstraint() {
        btnBackGroundView.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(97)
        }
        applyBtn.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        contentView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(63)
        }
        filterselectBtn.snp.makeConstraints{
            $0.top.equalToSuperview().offset(32)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(19)
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(btnBackGroundView.snp.top)
        }
    }
    
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "비교할 매물 고르기"
        
        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .plain, target: self, action: #selector(backBtnTap))
        backButtonItem.tintColor = .gray450
        backButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        let searchButtonItem = UIBarButtonItem(image: UIImage(named:"search"), style: .plain, target: self, action: #selector(searchBtnTap))
        searchButtonItem.tintColor = .gray450
        searchButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = searchButtonItem
    }
    
    @objc func backBtnTap() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func searchBtnTap() {
        let searchVC = CompareSearchViewController(imjangId: imjangId)
        searchVC.delegate = self.delegate as? SendSearchCompareImjangData
        navigationController?.pushViewController(searchVC, animated: true)
        tableView.reloadData()
        applyBtn.backgroundColor = .null
    }
    @objc func applyBtnTap(_ sender: UIButton) {
        let moveTo = scoreStates[sender] ?? false
        if moveTo {
            delegate?.sendData(isSelected: true, compareImjangId: comparedImjangId, compareImjangName: comparedName)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.view.makeToast("미평가된 매물은 비교하기 어려워요 :(", duration: 1.0)
        }
    }
    
    init(imjangId: Int) {
        self.imjangId = imjangId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        callRequest(setScrap: true, excludingId: imjangId)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .mainWhite
        
        view.addSubview(contentView)
        contentView.addSubview(filterselectBtn)
        view.addSubview(tableView)
        
        view.addSubview(btnBackGroundView)
        btnBackGroundView.addSubview(applyBtn)
        setFilterData()
        setConstraint()
    }
}

extension SelectMaemullViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imjangList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReportImjangListTableViewCell.identifier, for: indexPath) as! ReportImjangListTableViewCell
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .mainWhite
        cell.configureCell(imjangNote: imjangList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let compareImjangId = imjangList[indexPath.row].limjangId
        comparedImjangId = compareImjangId
        print("Row deselected at indexPath: \(compareImjangId)")
        
        let cell = tableView.cellForRow(at: indexPath) as! ReportImjangListTableViewCell
        comparedName = cell.roomNameLabel.text ?? "error"
        if cell.isSelect == false {
            cell.isSelect = true
            cell.contentView.backgroundColor = .main100
            cell.contentView.layer.borderColor = UIColor.main.cgColor
            applyBtn.backgroundColor = .gray500
            if let score = cell.scoreLabel.text {
                let moveTo = (score != "0.0")
                scoreStates[applyBtn] = moveTo
            }
            applyBtn.addTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        }
        else {
            cell.isSelect = false
            cell.contentView.backgroundColor = .mainWhite
            cell.contentView.layer.borderColor = UIColor.stroke.cgColor
            applyBtn.backgroundColor = .null
            applyBtn.removeTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReportImjangListTableViewCell
        cell.isSelect = false
        cell.contentView.backgroundColor = .mainWhite
        cell.contentView.layer.borderColor = UIColor.stroke.cgColor
        
        applyBtn.backgroundColor = .null
        applyBtn.removeTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }

}


