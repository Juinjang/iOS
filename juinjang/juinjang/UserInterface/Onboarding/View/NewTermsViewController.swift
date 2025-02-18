//
//  NewTermsViewController.swift
//  juinjang
//
//  Created by 박도연 on 12/28/24.
//

import UIKit
import Then
import SnapKit

protocol TermPopupDelegate: AnyObject {
    func didAgreeToTerms()
}

final class NewTermsViewController : BaseViewController {
    
    weak var delegate: TermPopupDelegate?
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "X"), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "주인장 개인정보처리방침"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1)
        $0.textAlignment = .center
    }
    
   private let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.indicatorStyle = .black
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = UIColor(named: "100")
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.892, green: 0.892, blue: 0.892, alpha: 1).cgColor
    }
    
    private let contentLabel1 = UILabel().then {
        $0.text = "개인정보처리방침"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let contentLabel2 = UILabel().then {
        $0.text = "1. 총칙\n주인장은 이용자의 개인정보를 소중히 생각합니다. 「개인정보보호법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」을 비롯한 개인정보 관련 법령을 준수하고 있습니다. 수집된 개인정보는 이용 동의를 받은 범위내에서 접근한다는 것을 고지, 승인 후에 수집되며 별도의 동의없이 제 3자에게 제공되지 않습니다. 본 개인정보처리방침은 이용자의 개인정보를 안전하게 처리하기 위해 마련되었으며 꾸준히 업데이트될 예정임을 알립니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel3 = UILabel().then {
        $0.text = "2. 개인정보의 처리목적\n주인장은 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음 목적 이외의 용도로 이용되지 아니하며, 이용 목적이 변경되는 경우에는 개인정보 보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.\n• 앱 서비스의 회원 가입 및 관리\n회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별 및 인증, 회원자격 유지와 관리, 제한적 본인확인제 시행에 따른 본인확인, 서비스 부정이용 방지, 각종 고지 및 통지, 고충처리 등을 목적으로 개인정보를 처리합니다.\n• 재화 또는 서비스 제공\n물품배송, 서비스 제공, 계약서 및 청구서 발송, 콘텐츠 제공, 맞춤서비스 제공, 본인인증, 연령인증, 요금결제 및 정산, 포인트 적립 및 이용, 채권추심 등을 목적으로 개인정보를 처리합니다.\n• 고충처리\n민원인의 신원 확인, 민원사항 확인, 사실조사를 위한 연락 및 통지, 처리결과 통보 등의 목적으로 개인정보를 처리합니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel4 = UILabel().then {
        $0.text = "3. 수집하는 개인정보의 항목\n가. 주인장(당사)은 서비스 이용, 이벤트 응모, 팩스, 우편, 전화, 고객센터 문의하기 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.\n해당 서비스의 본질적 기능을 수행하기 위한 정보는 필수항목으로서 수집하며 이용자가 그 정보를 회사에 제공하지 않는 경우 서비스 이용에 제한이 가해질 수 있지만, 선택항목으로 수집되는 정보의 경우에는 이를 입력하지 않은 경우에도 서비스 이용제한은 없습니다.\n추가항목은 휴대폰 감면권 신청, 기부금 영수증 발행 등의 경우 해당 신청자에 한해 추가적으로 수집합니다. 단, 만14세 미만 아동의 개인정보는 수집하지 않습니다.\n나. 수집항목, 이용목적, 보유기간\n• 수집 항목\n1. 회원가입시 수집하는 항목\n① 개인 회원\n필수항목: 이름,닉네님 및 이메일,카카오톡,애플 등 외부 서비스와의 연동을 통해 이용자가 설정한 계정 정보\n2. 서비스 이용과정이나 사업처리 과정에서 자동 수집되는 항목\nIP Address, 쿠키, 방문 일시, 서비스 이용 기록, 불량 이용 기록, 광고 ID,접속 환경\n• 수집 및 이용목적\n1. 회원관리\n회원제 서비스 이용에 따른 본인확인, 본인의 의사확인, 고객문의에 대한 응답, 새로운 정보의 소개 및 고지사항 전달\n2. 서비스 제공에 관한 계약 이행 및 서비스 제공\n부정 이용방지와 비인가 사용방지\n3. 서비스 개발 및 마케팅ㆍ광고 활용\n맞춤 서비스 제공, 서비스 안내 및 이용권유, 서비스 개선 및 신규 서비스 개발을 위한 통계 및 접속빈도 파악, 통계학적 특성에 따른 광고, 이벤트 정보 및 참여기회 제공\n4. 고용 및 취업동향 파악을 위한 통계학적 분석, 서비스 고도화를 위한 데이터 분석\n• 보유기간\n회원탈퇴 후 30일 이내 또는 법령에 따른 보존기간(단, 부정이용 확인 시 회원탈퇴 후 6개월)\n기타 거래처 뉴스레터 발송, 각종 이벤트, 마케팅, 설문조사 등을 위하여 해당 발송에 대한 수신동의를 받아 이메일을 수집하고 있으며, 각종 이벤트시 그 내용에 따라 추가 항목들을 제공받아 이용하고 있습니다.그리고 중복가입방지, 문의사항처리, 부정 이용자 제재, 포인트 정산, 공지사항 전달, 분쟁조정을 위한 기록보존 등 회원관리와 신규 서비스 개발을 위한 통계적 분석을 위해 서비스 이용기록 등의 사항들을 저장하고 있습니다.\n다. 개인정보 수집방법\n• 주인장는 온라인 회원가입, 회원정보수정, 서비스 이용, 단말기를 통한 자동수집, 이메일과 같은 방법을 통하여 개인정보를 수집합니다.\n• 이용자의 사상, 신념, 과거의 병력 등 개인의 권리, 이익이나 사생활을 뚜렷하게 침해할 우려가 있는 민감정보는 수집하지 않으며, 회사는 이용자의 개인정보를 수집할 때, 사전에 해당 사실을 이용자에게 알리고 동의를 구합니다.\n• 다만, 이용자가 요구하는 서비스를 제공하는 과정에서 이를 이행하기 위하여 필요한 개인정보로서 경제적, 기술적 사유로 통상적인 동의를 받는 것이 뚜렷하게 곤란한 경우, 서비스 제공에 따른 요금정산을 위하여 필요한 경우, 기타 정보통신망법 또는 다른 법률에 특별한 규정이 있는 경우에는 동의를 받지 않고 이용자의 개인정보를 수집할 수 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel5 = UILabel().then {
        $0.text = "4. 개인 정보의 위탁\n• 개인정보 국외처리 위탁 현황"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let imageView2 = UIImageView().then {
        $0.image = UIImage(named: "useImage2")
        $0.contentMode = .scaleAspectFit
    }
    
    private let contentLabel6 = UILabel().then {
        $0.text = "*해당 개인정보 위탁 처리 및 보유 기간은 수집하는 개인정보의 항목에 명시된 사항과 같습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel7 = UILabel().then {
        $0.text = "5. 개인정보의 파기 절차 및 방법\n주인장은 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.\n가. 파기절차\n이용자가 회원가입 등을 위해 입력하신 정보는 목적이 달성된 후 별도의 DB 로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기됩니다. 별도 DB 로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 보유되는 이외의 다른 목적으로 이용되지 않습니다.\n나. 파기기한\n이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유 기간의 종료일로부터 30일 이내에 파기하며 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 30일 이내에 그 개인정보를 파기합니다.\n다. 파기방법\n종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기하며,\n라. 장기 미이용자의 개인정보 파기\n정보통신망법에 따라 회원가입 후 서비스 이용이 없는 고객 및 12개월 이상 로그인하지 않은 경우 해당 이용자 ID 및 개인정보를 유효기간 경과 후 즉시 파기하거나, 분리하여 보관합니다. 이러한 경우 위 12개월의 기간 도래 30일 전까지 회사는 이용자의 개인정보가 분리되어 저장, 관리되고 있다는 사실과 기간 만료일 및 해당 개인정보의 항목을 전자우편, 서면, 모사전송, 전화 또는 이와 유사한 방법 중 어느 하나의 방법으로 이용자에게 알려드립니다. 명시한 기한 내에 로그인 하지 않거나 서비스 이용이 없는 경우에는 회원자격을 상실시킬 수 있습니다. 이 경우, 회원 아이디를 포함한 회원의 개인정보 및 서비스 이용 정보는 파기, 삭제됩니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel8 = UILabel().then {
        $0.text = "6. 이용자 및 법정대리인의 권리와 그 행사방법\n주인장은 이용자 및 법정대리인의 권리를 다음과 같이 보호하고 있습니다.\n가. 언제든지 자신의 개인정보를 조회하고 수정할 수 있습니다.\n나. 언제든지 개인정보 제공에 관한 동의철회/회원가입 해지를 요청할 수 있습니다.\n다. 정확한 개인정보의 이용 및 제공을 위해 이용자가 개인정보 수정 진행 시 수정이 완료될 때까지 이용자의 개인정보는 이용되거나 제공되지 않습니다. 이미 제 3 자에게 제공된 경우에는 지체 없이 제공받은 자에게 사실을 알려 수정이 이루어질 수 있도록 하겠습니다.\n권리 행사는 juinjang1227@gmail.com을 통해서 할 수 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel9 = UILabel().then {
        $0.text = "7. 개인정보에 관한 민원서비스\n주인장은 개인정보보호책임 업무를 맡고 있는 팀원을 배정하여 개인정보 처리방침의 이행사항을 준수하고 있습니다.\n관련 문의 : juinjang1227@gmail.com"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let agreeButton = UIButton().then {
        $0.setTitle("동의하고 화면 닫기", for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.titleLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.backgroundColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
        $0.layer.cornerRadius = 10
    }
    
//MARK: - 함수
    @objc private  func tapCloseButton() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func agreeButtonTapped() {
        delegate?.didAgreeToTerms()
        dismiss(animated: false, completion: nil)
    }
    
    private func setConstraint() {
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(17.16)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(12)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(160)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(92.16)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(101)
        }
        contentLabel1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(16)
        }
        contentLabel2.snp.makeConstraints {
            $0.top.equalTo(contentLabel1.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel3.snp.makeConstraints {
            $0.top.equalTo(contentLabel2.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel4.snp.makeConstraints {
            $0.top.equalTo(contentLabel3.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel5.snp.makeConstraints {
            $0.top.equalTo(contentLabel4.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        imageView2.snp.makeConstraints {
            $0.top.equalTo(contentLabel5.snp.bottom)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
            $0.height.equalTo(210)
        }
        contentLabel6.snp.makeConstraints {
            $0.top.equalTo(imageView2.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel7.snp.makeConstraints {
            $0.top.equalTo(contentLabel6.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel8.snp.makeConstraints {
            $0.top.equalTo(contentLabel7.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel9.snp.makeConstraints {
            $0.top.equalTo(contentLabel8.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        agreeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentLabel1)
        scrollView.addSubview(contentLabel2)
        scrollView.addSubview(contentLabel3)
        scrollView.addSubview(contentLabel4)
        scrollView.addSubview(contentLabel5)
        scrollView.addSubview(imageView2)
        scrollView.addSubview(contentLabel6)
        scrollView.addSubview(contentLabel7)
        scrollView.addSubview(contentLabel8)
        scrollView.addSubview(contentLabel9)
        view.addSubview(agreeButton)
        
        closeButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)

        contentLabel2.asFont(targetString: "1. 총칙", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel3.asFont(targetString: "2. 개인정보의 처리목적", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel4.asFont(targetString: "3. 수집하는 개인정보의 항목", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel5.asFont(targetString: "4. 개인 정보의 위탁", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel7.asFont(targetString: "5. 개인정보의 파기 절차 및 방법", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel8.asFont(targetString: "6. 이용자 및 법정대리인의 권리와 그 행사방법", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel9.asFont(targetString: "7. 개인정보에 관한 민원서비스", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        view.backgroundColor = .white
        
        setConstraint()
    }
}

