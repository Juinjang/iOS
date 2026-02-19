//
//  ReportViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/22/24.
//

import UIKit
import Then
import SnapKit

import Tabman
import Pageboy

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKShare
import SafariServices

import Alamofire
import RxSwift

final class ReportViewController : BaseViewController {
    private let onboardingRepository = OnboardingRepository()
    let templateId = 103560
    var safariViewController : SFSafariViewController?
    var checkListViewController: CheckListViewController?
    private var disposeBag = DisposeBag()
    
    private let navigationView = DefaultNavigationView().then {
        $0.title = "주인장 리포트"
        $0.leftItem = [.pop]
    }
    
    //MARK: - 총 평점 멘트, 가격, 주소
    var totalGradeLabel = UILabel().then {
        $0.textColor = .gray600
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pretendard(size: 24, weight: .bold)
    }
    var imjangLabel = UILabel()
    var priceLabel = UILabel().then {
        $0.textColor = .gray450
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pretendard(size: 20, weight: .semiBold)
    }
    var addressLabel = UILabel().then {
        $0.textColor = .gray400
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.numberOfLines = 0
    }
    
    var imjangId: Int
    var indoorRate: Float = 0.0
    var indoorKeyWord : String = ""
    var locationConditionsRate : Float = 0.0
    var locationConditionsWord : String = ""
    var publicSpaceRate : Float = 0.0
    var publicSpaceKeyWord : String = ""
    var savedCheckListItems: [CheckListAnswer]
    var checkListDatadelegate: SendCheckListData?
   // var reportId : Int = 0
    var totalRate : Float = 0.0
   
    //MARK: - 그래프
    var tabViewController = TabViewController()
    
    
    init(imjangId: Int, savedCheckListItems: [CheckListAnswer]) {
        self.imjangId = imjangId
        tabViewController.imjangId = imjangId
        self.savedCheckListItems = savedCheckListItems
        super.init()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReportInfo(limjangId: imjangId, accessToken: UserDefaultManager.shared.accessToken)
        print(imjangId)
        view.backgroundColor = .mainWhite
        
        view.add(
            navigationView,
            totalGradeLabel,
            priceLabel,
            addressLabel
        )
        
        addChild(tabViewController)
        view.addSubview(tabViewController.view)
        tabViewController.didMove(toParent: self)
        
        setConstraint()
    }
    
    func getReportInfo(limjangId: Int, accessToken: String) {
        if UserDefaultManager.shared.isOnboarding {
            setLoading(isShow: true)
            onboardingRepository.retrieveMyNoteReport()
                .asObservable()
                .subscribe(with: self) { (self, response) in
                    self.setLoading(isShow: false)
                    self.setData(reportDto: response.reportDTO)
                    self.setData(detailDto: response.limjangDto)
                }
                .disposed(by: disposeBag)
            
            return
        }
        
        setLoading(isShow: true)
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<ReportResponseDto>.self, api: .fetchReportInfo(imjangId: limjangId)) { [weak self] response, error in
            guard let self else { return }
            self.setLoading(isShow: false)
            if error == nil {
                guard let response, let result = response.result else {
                    print("fetch Report Info Response is Empty")
                    return
                }
                setData(reportDto: result.reportDTO)
                setData(detailDto: result.limjangDto)
            } else {
                print("fetch Report Info Error")
            }
        }
    }
    
    func setConstraint() {
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        totalGradeLabel.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        priceLabel.snp.makeConstraints{
            $0.top.equalTo(totalGradeLabel.snp.bottom).offset(13)
            $0.leading.equalToSuperview().offset(24)
        }
        
        addressLabel.snp.makeConstraints{
            $0.top.equalTo(priceLabel.snp.bottom).offset(6)
            $0.height.equalTo(23)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
       
        tabViewController.view.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(190)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        navigationView.itemActionRelay
            .bind(with: self, onNext: { owner, action in
                switch action {
                case .popButtonTap: owner.backBtnTap()
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func changeItem() {
        self.navigationItem.rightBarButtonItem = .none
    }
    
    func setData(detailDto: DetailDto) {
        imjangLabel.text = detailDto.nickname
        imjangLabel.numberOfLines = 0
        
        let star = NSTextAttachment()
        star.image = UIImage.Report.bigStar
        
        let attrString = NSMutableAttributedString(string: "\(String(format: "%.2f", totalRate))점입니다")
        let range = ("\(String(format: "%.2f", totalRate))점입니다" as NSString).range(of: "\(String(format: "%.2f", totalRate))점")
        attrString.addAttribute(.foregroundColor, value: UIColor.main, range: range)
        let text3 = NSMutableAttributedString(string: "\(imjangLabel.text ?? "")의\n총점은")
        text3.append(NSAttributedString(attachment: star))
        text3.append(NSAttributedString(attributedString: attrString))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        text3.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text3.length))
        totalGradeLabel.attributedText = text3
        let priceTypeString: String
        switch detailDto.priceType {
        case 0: priceTypeString = "매매"
        case 1: priceTypeString = "전세"
        case 2: priceTypeString = "월세"
        case 3: priceTypeString = "실거래가"
        default:
            priceTypeString = "" // 값이 없을 경우 공백 처리
        }
        setPriceLabel(priceList: detailDto.priceList, priceType: priceTypeString)
        if let address = detailDto.address {
            addressLabel.text = "\(address) \(detailDto.addressDetail ?? "")"
        } else {
            addressLabel.text = "주소 미입력"
            addressLabel.textColor = .null
        }
        
        tabViewController.compareVC.compareLabel1.text = detailDto.nickname.count > 12 ? "\(detailDto.nickname.prefix(11))﹒﹒﹒" : detailDto.nickname
        tabViewController.compareVC.chartCompareLabel1.text = detailDto.nickname.count > 12 ? "\(detailDto.nickname.prefix(11))﹒﹒﹒" : detailDto.nickname
    }
    
    func setData(reportDto: ReportDTO) {
        indoorKeyWord = reportDto.indoorKeyWord
        indoorRate = reportDto.indoorRate
        
        locationConditionsWord = reportDto.locationConditionsWord
        locationConditionsRate = reportDto.locationConditionsRate
        
        publicSpaceKeyWord = reportDto.publicSpaceKeyWord
        publicSpaceRate = reportDto.publicSpaceRate
        
        totalRate = reportDto.totalRate
        
        let graphVC = tabViewController.graphVC
        graphVC.updateLabel(with: indoorKeyWord, status2: locationConditionsWord, status3: publicSpaceKeyWord)
        graphVC.updateRate(rate: String(format: "%.2f", indoorRate), label: graphVC.indoorRateLabel)
        graphVC.updateRate(rate: String(format: "%.2f", locationConditionsRate), label: graphVC.locationRateLabel)
        graphVC.updateRate(rate: String(format: "%.2f", publicSpaceRate), label: graphVC.publicRateLabel)
        graphVC.setData(indoor: indoorRate, location: locationConditionsRate, publicSpace: publicSpaceRate)
        
        let compareVC = tabViewController.compareVC
        compareVC.updateRate(rate: String(format: "%.2f", indoorRate), label: compareVC.insideRateLabel1)
        compareVC.updateRate(rate: String(format: "%.2f", locationConditionsRate), label: compareVC.locationConditionRateLabel1)
        compareVC.updateRate(rate: String(format: "%.2f", publicSpaceRate), label: compareVC.publicSpaceRateLabel1)
        compareVC.updateRate(rate: String(format: "%.2f", totalRate), label: compareVC.totalRateLabel1)
        compareVC.setData(indoor: indoorRate, location: locationConditionsRate, publicSpace: publicSpaceRate)

    }
    
    func setPriceLabel(priceList: [String?], priceType: String) {
        switch priceList.count {
        case 1:
            guard
                let priceString = priceList.first ?? nil,
                let priceInt = Int(priceString),
                priceInt > 0
            else {
                priceLabel.text = "가격 미입력"
                return
            }
            
            let formatted = priceString.formatToKoreanCurrencyWithZero()
            
            priceLabel.text = priceType.isEmpty
            ? formatted
            : "\(priceType) \(formatted)"
        case 2:
            guard
                let deposit = priceList[safe: 0] ?? nil,
                let rent = priceList[safe: 1] ?? nil,
                let rentInt = Int(rent),
                rentInt > 0
            else {
                priceLabel.text = "가격 미입력"
                return
            }
            
            let formattedDeposit = deposit.formatToKoreanCurrencyWithZero()
            let formattedRent = rent.oneSplitAmount().addingCommas()
            
            priceLabel.text = "\(priceType) \(formattedDeposit) / \(formattedRent)"
        default:
            priceLabel.text = "편집을 통해 가격을 설정해주세요."
        }
    }
    
    @objc func backBtnTap() {
        NotificationCenter.default.post(name: NSNotification.Name("ReloadTableView"), object: nil)
        checkListDatadelegate?.sendData(
            savedCheckListItems: savedCheckListItems
        )
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareBtnTap() {
        if ShareApi.isKakaoTalkSharingAvailable() {
            // 카카오톡으로 카카오톡 공유 가능
            ShareApi.shared.shareCustom(templateId: Int64(templateId), templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {(sharingResult, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("shareCustom() success.")
                    if let sharingResult = sharingResult {
                        UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        else {
            // 카카오톡 미설치: 웹 공유 사용 권장
            // Custom WebView 또는 디폴트 브라우져 사용 가능
            // 웹 공유 예시 코드
            if let url = ShareApi.shared.makeCustomUrl(templateId: Int64(templateId), templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {
                self.safariViewController = SFSafariViewController(url: url)
                self.safariViewController?.modalTransitionStyle = .crossDissolve
                self.safariViewController?.modalPresentationStyle = .overCurrentContext
                self.present(self.safariViewController!, animated: true) {
                    print("웹 present success")
                }
            }
        }
    }
    
    func updateUI(with items: [CheckListAnswer]) {
        self.savedCheckListItems = items
    }
}

protocol SendCheckListData {
    func sendData(savedCheckListItems: [CheckListAnswer])
}
