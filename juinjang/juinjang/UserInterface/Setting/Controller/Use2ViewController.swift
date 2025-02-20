//
//  UseViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/10/24.
//

import UIKit
import Then
import SnapKit

final class Use2ViewController : BaseViewController {
    
    private let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.indicatorStyle = .black
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 10  // cornerRadius 추가
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.stroke.cgColor
        $0.clipsToBounds = true
    }
    
    // 드롭다운 버튼 추가
    private let dropdownButton = UIButton().then {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        configuration.title = "이용약관 버전 1.1.0 (시행일 2025.01.12)"
        configuration.baseForegroundColor = .gray450
        configuration.background.backgroundColor = .mainWhite
        
        // 폰트 설정
        var titleAttr = AttributedString.init("이용약관 버전 1.1.0 (시행일 2025.01.12)")
        titleAttr.font = UIFont(name: "Pretendard-Medium", size: 16)
        configuration.attributedTitle = titleAttr
        $0.configuration = configuration
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.stroke.cgColor
        $0.contentHorizontalAlignment = .left
    }
    
    private let dropdownImageView = UIImageView().then {
        $0.image = UIImage(named: "dropdown")
        $0.contentMode = .scaleAspectFit
    }
    
    private let dropdownTableView = UITableView().then {
        $0.isHidden = true
        $0.backgroundColor = .mainWhite
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.stroke.cgColor
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "VersionCell")
    }
    
    private let versions = ["이용약관 버전 1.1.0 (시행일 2025.01.12)", "이용약관 버전 1.0.0 (시행일 2024.09.11)"]
    private var isDropdownVisible = false
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "useImage")
        $0.contentMode = .scaleAspectFit
    }
    private let imageView2 = UIImageView().then {
        $0.image = UIImage(named: "useImage2")
        $0.contentMode = .scaleAspectFit
    }
    private let imageView3 = UIImageView().then {
        $0.image = UIImage(named: "useImage3")
        $0.contentMode = .scaleAspectFit
    }
    

    private let contentLabel1 = UILabel().then {
        $0.text = "개인정보처리방침"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let contentLabel2 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel3 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel4 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel5 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel6 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel7 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel8 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel9 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel10 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel11 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
//MARK: - 함수
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "주인장 개인정보 처리방침"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(named:"arrow-left"), style: .plain, target: self, action: #selector(tapCloseButton))
        closeButtonItem.tintColor = .gray450
        closeButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = closeButtonItem
    }
    @objc func tapCloseButton() {
        _ = self.navigationController?.popViewController(animated: false)
    }
    @objc private func dropdownButtonTapped() {
        isDropdownVisible.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.dropdownTableView.isHidden = !self.isDropdownVisible
            let tableHeight = 63 * self.versions.count
            self.dropdownTableView.snp.updateConstraints {
                $0.height.equalTo(self.isDropdownVisible ? tableHeight : 0)
            }
            self.dropdownImageView.transform = self.isDropdownVisible ?
                CGAffineTransform(rotationAngle: .pi) : .identity
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateContent(forVersion version: String) {
        switch version {
        case "이용약관 버전 1.0.0 (시행일 2024.09.11)":
            print("구버전")
            contentLabel2.text = "주인장은 개인정보보호법 등 관련 법령에 따라 이용자의 개인정보를 보호하고, 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보처리방침을 수립합니다.\n개인정보처리방침은 이용자가 언제나 쉽게 열람할 수 있도록 서비스 초기화면을 통해 공개하고 있으며 관련법령, 지침, 고시 또는 밥먹공서비스 정책의 변경에 따라 달라질 수 있습니다."
            contentLabel3.text = "1. 개인정보의 수집/이용\n주인장은 다음과 같이 개인정보를 수집합니다. 처리하고 있는 개인정보는 다음의 수집/이용 목적 이외의 용도로는 활용되지 않으며, 수집/이용 목적이 변경되는 경우에는 개인정보보호법에 따라 별도의 동의를 받는 등 필요한 조치를 이행합니다.\n(1) 회원가입 시 본인인증 및 회원가입 유형에 따라 다음의 개인정보를 수집 이용합니다.\n - 타사 계정을 이용한 회원가입 시: 닉네임, 이메일주소, 계정 식별자\n *타사 계정 가입 시 제3자로부터 제공받는 개인정보는 다음과 같습니다.\n - 네이버: CI, 이메일주소, 카카오 계정 식별자, 닉네임\n - Apple: CI, 이메일주소, Apple ID식별자\n(2) 회원은 주인장이 제공하는 서비스를 선택적으로 이용할 수 있으며, 이용 서비스에 따라 아래와 같이 개인정보를 추가 수집 이용합니다."
            contentLabel4.text = "(3) 서비스 이용과정에서 아래 자동 수집 정보가 생성되어 수집 저장, 조합, 분석될 수 있습니다.\n - IP주소, 쿠키, 방문기록, 서비스 이용기록(검색이력, 서비스 사용이력 등)\n(4) 주인장은 서비스 제공을 위하여 수집한 모든 개인정보와 생성정보를 아래 목적으로 이용합니다\n - 회원 가입 의사 확인, 이용자 동의 의사 확인, 회원제 서비스 제공, 회원관리\n - 이용자 식별, 학생인증\n - 민원처리 및 고객상담\n - 고지사항 전달\n - 불법 및 부정이용 방지, 부정 사용자 차단 및 관리\n - 서비스 방문 및 이용기록 통계 및 분석\n - 서비스 만족도 조사 및 관리\n - 맞춤 서비스, 개인화 서비스 제공\n - 마케팅 및 프로모션 활용(광고성/이벤트 정보 제공), 맞춤형 광고 제공"
            contentLabel5.text = "2. 개인정보 파기절차 및 방법\n(1) 주인장은 이용자의 개인정보를 원칙적으로 보유/이요기간 경과, 처리목적 달성, 서비스 이용약관에 따른 계약 해지 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.\n(2) 이용자로부터 동의 받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는 해당 개인정보를 별도의 데이터페이서(DB)로 옮기거나 보관장소를 달리하여 보존합니다.\n① 다른 법령에 따라 개인정보를 보관하는 경우는 다음과 같습니다."
            contentLabel6.text = "② 주인장 내부정책에 의하여 이용자의 동의를 받아 개인정보를 보관하는 경우는 다음과 같습니다"
            contentLabel7.text = "(3) 주인장은 1년 동안 주인장서비스를 이용하지 않은 이용자의 개인정보는 '개인정보보호법 제39조의 6(개인정보의 파기에 대한 특례)'에 근거하여 이용자에게 사정통지하고 휴면회원으로 전환하며 개인정보를 별도 분리하여 저장합니다.\n이용자는 언제든지 휴면 해제 후 서비스를 이용할 수 있으며, 휴면회원으로 전환된 날로부터 1년 이상 휴면 해제하지 않는 경우 주인장의 계정 탈퇴와 함께 분리 보관된 이용자의 개인정보를 파기합니다. 주인장은 휴면회원 전환 30일전, 개인정보가 분리되어 저장/관리된다는 사실, 서비스 미이용 기간 만료일, 분리 저장하는 개인정보의 항목을 전자우편 등의 방법으로 알리며, 휴면회원 전환 및 탈퇴 처리 시에도 동일한 방법으로 즉시 이용자에게 알랍니다.\n(4) 개인정보 파기의 절차 및 방법은 다음과 같습니다.\n①파기절차\n주인장은 파기 사유가 발생한 개인정보를 개인정보 보호책임자의 승인 절차를 거쳐 파기합니다.\n②파기방법\n주인장은 전자적 파일형태로 기록/저장된 개인정보는 기록을 재생할 수 없도록 기술적인 방법 또는 물리적인 방법을 이용하여 파기하며, 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각 등을 통하여 파기합니다."
            contentLabel8.text = "3. 이용자의 권리와 그 행사방법\n(1) 이용자는 '설정 > 내 정보'에서 직접 자신의 개인정보를 열람, 정정, 삭제, 처리정지 또는 가입 해지하는 것을 원칙으로 하며, 주인장은 이를 위한 기능을 제공합니다.\n(2) 이용자는 유선 또는 메일을 통해 개인정보의 열람, 정정, 삭제, 처리정지 또는 가입 해지를 요청할 수 있으며, 주인장은 정책에 따라 본인확인 절차를 거쳐 이를 조치하겠습니다. • 전자우편: juinjang1227@gmail.com\n(3) 주인장은 다음에 해당하는 경우 개인정보의 열람, 정정, 삭제, 처리정지 등을 거절할 수 있습니다.\n① 법률에 따라 열람, 정정, 삭제, 처리정지 등이 금지되거나 제한되는 경우\n② 다른 사람의 생명, 신체를 해할 우려가 있거나 다른 사람의 재산과 그 밖의 이익을 부당하게 침해할 우려가 있는 경우\n(4) 이용자가 개인정보의 오류에 대한 정정을 요청한 경우에는 정정을 완료하기 전까지 당해 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리 결과를 제3자에게 지체없이 통지하여 정정이 이루어지도록 하겠습니다.\n(5) 이용자는 자신의 개인정보를 최신의 상태로 유지해야 하며, 이용자의 부정확한 정보 입력으로 발생하는 문제의 책임은 이용자 자신에게 있습니다.\n(6) 타인의 개인정보를 도용한 회원가입의 경우 이용자 자격을 상실하거나 관련 개인정보보호 법령에 의해 처벌받을 수 있습니다.\n(7) 이용자는 전자우편, 비밀번호 등에 대한 보안을 유지할 책임이 있으며 제3자에게 이를 양도하거나 대여 할 수 없습니다."
            contentLabel9.text = "4. 개인정보의 기술적/관리적 보호대책\n주인장은 이용자의 개인정보를 처리함에 있어 개인정보가 분실, 도난, 유출, 변조, 훼손 등이 되지 않도록 안전성을 확보하기 위하여 다음과 같이 기술적/관리적 보호대책을 강구하고 있습니다.\n(1) 비밀번호의 암호화\n이용자의 비밀번호는 일방향 암호화하여 저장 및 관리되고 있으며, 개인정보의 확인, 변경은 비밀번호를 알고있는 본인에 의해서만 가능합니다.\n(2) 해킹 등에 대비한 대책\n① 주인장은 해킹, 컴퓨터 바이러스 등 정보통신망 침입에 의해 이용자의 개인정보가 유출되거나 훼손되는 것을 막기 위해 최선을 다하고 있습니다.\n② 최신 백신프로그램을 이용하여 이용자들의 개인정보나나 자료가 유출되거나 손상되지 않도록 방지하고 있습니다.\n③ 만일의 사태에 대비하여 침입차단 시스템을 이용하여 보안에 최선을 다하고 있습니다.\n④ 민감한 개인정보는 암호화 통신 등을 통하여 네트워크상에서 개인정보를 안전하게 전송할 수 있도록 하고 있습니다.\n(3) 개인정보 처리 최소화 및 교육\n주인장은 개인정보 관련 처리 담당자를 최소한으로 제한하며, 개인정보 처리자에 대한 교육 등 관리적 조치를 통해 법령 및 내부방침 등의 준수를 강조하고 있습니다."
            contentLabel10.text = "5. 개인정보 보호 책임자\n(1) 주인장은 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 고객님의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n- 개인정보 보호 책임자: 여민경\n- 전자우편: juinjang1227@gmail.com"
            contentLabel11.text = "6. 고지의 의무\n(1) 현 개인정보처리방침은 법령, 정부의 정책 또는 주인장내부정책 등 필요에 의하여 변경될 수 잇으며, 내용추가, 삭제 및 수정이 있을 시에는 개정 최소 7일전부터 '공지사항'을 통해 고지할 것 입니다. 다만, 이용자 권리의 중요한 변경이 있을 경우에는 최소 30일 전에 고지합니다.\n(2) 현 개인정보처리방침은 2024년 1월 26일부터 적용되며, 변경 전의 개인정보처리방침은 공지사항을 통해서 확인하실 수 있습니다.\n- 공고일자 2024년 1월 26일\n- 시행일자 2024년 1월 26일"
            
            contentLabel3.asFont(targetString: "1. 개인정보의 수집/이용", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel5.asFont(targetString: "2. 개인정보 파기절차 및 방법", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel5.asFont(targetString: "3. 이용자의 권리와 그 행사방법", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel9.asFont(targetString: "4. 개인정보의 기술적/관리적 보호대책", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel10.asFont(targetString: "5. 개인정보 보호 책임자", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel11.asFont(targetString: "6. 고지의 의무", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            
            contentLabel10.isHidden = false
            contentLabel11.isHidden = false
            
            imageView.isHidden = false
            imageView3.isHidden = false
            imageView.image = UIImage(named: "useImage")
            imageView2.image = UIImage(named: "useImage2")
            imageView3.image = UIImage(named: "useImage3")
            
            // 이미지뷰 관련 constraint 활성화
            imageView.snp.updateConstraints {
                $0.height.equalTo(130)
            }
            imageView2.snp.updateConstraints {
                $0.height.equalTo(210)
            }
            imageView3.snp.updateConstraints {
                $0.height.equalTo(120)
            }
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentLabel11.frame.maxY + 16)
        case "이용약관 버전 1.1.0 (시행일 2025.01.12)":
            print("신버전")
            contentLabel2.text = "1. 총칙\n주인장은 이용자의 개인정보를 소중히 생각합니다. 「개인정보보호법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」을 비롯한 개인정보 관련 법령을 준수하고 있습니다. 수집된 개인정보는 이용 동의를 받은 범위내에서 접근한다는 것을 고지, 승인 후에 수집되며 별도의 동의없이 제 3자에게 제공되지 않습니다. 본 개인정보처리방침은 이용자의 개인정보를 안전하게 처리하기 위해 마련되었으며 꾸준히 업데이트될 예정임을 알립니다."
            contentLabel3.text = "2. 개인정보의 처리목적\n주인장은 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음 목적 이외의 용도로 이용되지 아니하며, 이용 목적이 변경되는 경우에는 개인정보 보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.\n• 앱 서비스의 회원 가입 및 관리\n회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별 및 인증, 회원자격 유지와 관리, 제한적 본인확인제 시행에 따른 본인확인, 서비스 부정이용 방지, 각종 고지 및 통지, 고충처리 등을 목적으로 개인정보를 처리합니다.\n• 재화 또는 서비스 제공\n물품배송, 서비스 제공, 계약서 및 청구서 발송, 콘텐츠 제공, 맞춤서비스 제공, 본인인증, 연령인증, 요금결제 및 정산, 포인트 적립 및 이용, 채권추심 등을 목적으로 개인정보를 처리합니다.\n• 고충처리\n민원인의 신원 확인, 민원사항 확인, 사실조사를 위한 연락 및 통지, 처리결과 통보 등의 목적으로 개인정보를 처리합니다."
            contentLabel4.text = "3. 수집하는 개인정보의 항목\n가. 주인장(당사)은 서비스 이용, 이벤트 응모, 팩스, 우편, 전화, 고객센터 문의하기 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.\n해당 서비스의 본질적 기능을 수행하기 위한 정보는 필수항목으로서 수집하며 이용자가 그 정보를 회사에 제공하지 않는 경우 서비스 이용에 제한이 가해질 수 있지만, 선택항목으로 수집되는 정보의 경우에는 이를 입력하지 않은 경우에도 서비스 이용제한은 없습니다.\n추가항목은 휴대폰 감면권 신청, 기부금 영수증 발행 등의 경우 해당 신청자에 한해 추가적으로 수집합니다. 단, 만14세 미만 아동의 개인정보는 수집하지 않습니다.\n나. 수집항목, 이용목적, 보유기간\n• 수집 항목\n1. 회원가입시 수집하는 항목\n① 개인 회원\n필수항목: 이름,닉네님 및 이메일,카카오톡,애플 등 외부 서비스와의 연동을 통해 이용자가 설정한 계정 정보\n2. 서비스 이용과정이나 사업처리 과정에서 자동 수집되는 항목\nIP Address, 쿠키, 방문 일시, 서비스 이용 기록, 불량 이용 기록, 광고 ID,접속 환경\n• 수집 및 이용목적\n1. 회원관리\n회원제 서비스 이용에 따른 본인확인, 본인의 의사확인, 고객문의에 대한 응답, 새로운 정보의 소개 및 고지사항 전달\n2. 서비스 제공에 관한 계약 이행 및 서비스 제공\n부정 이용방지와 비인가 사용방지\n3. 서비스 개발 및 마케팅ㆍ광고 활용\n맞춤 서비스 제공, 서비스 안내 및 이용권유, 서비스 개선 및 신규 서비스 개발을 위한 통계 및 접속빈도 파악, 통계학적 특성에 따른 광고, 이벤트 정보 및 참여기회 제공\n4. 고용 및 취업동향 파악을 위한 통계학적 분석, 서비스 고도화를 위한 데이터 분석\n• 보유기간\n회원탈퇴 후 30일 이내 또는 법령에 따른 보존기간(단, 부정이용 확인 시 회원탈퇴 후 6개월)\n기타 거래처 뉴스레터 발송, 각종 이벤트, 마케팅, 설문조사 등을 위하여 해당 발송에 대한 수신동의를 받아 이메일을 수집하고 있으며, 각종 이벤트시 그 내용에 따라 추가 항목들을 제공받아 이용하고 있습니다.그리고 중복가입방지, 문의사항처리, 부정 이용자 제재, 포인트 정산, 공지사항 전달, 분쟁조정을 위한 기록보존 등 회원관리와 신규 서비스 개발을 위한 통계적 분석을 위해 서비스 이용기록 등의 사항들을 저장하고 있습니다.\n다. 개인정보 수집방법\n• 주인장는 온라인 회원가입, 회원정보수정, 서비스 이용, 단말기를 통한 자동수집, 이메일과 같은 방법을 통하여 개인정보를 수집합니다.\n• 이용자의 사상, 신념, 과거의 병력 등 개인의 권리, 이익이나 사생활을 뚜렷하게 침해할 우려가 있는 민감정보는 수집하지 않으며, 회사는 이용자의 개인정보를 수집할 때, 사전에 해당 사실을 이용자에게 알리고 동의를 구합니다.\n• 다만, 이용자가 요구하는 서비스를 제공하는 과정에서 이를 이행하기 위하여 필요한 개인정보로서 경제적, 기술적 사유로 통상적인 동의를 받는 것이 뚜렷하게 곤란한 경우, 서비스 제공에 따른 요금정산을 위하여 필요한 경우, 기타 정보통신망법 또는 다른 법률에 특별한 규정이 있는 경우에는 동의를 받지 않고 이용자의 개인정보를 수집할 수 있습니다."
            contentLabel5.text = "4. 개인 정보의 위탁\n• 개인정보 국외처리 위탁 현황"
            contentLabel6.text = "*해당 개인정보 위탁 처리 및 보유 기간은 수집하는 개인정보의 항목에 명시된 사항과 같습니다."
            contentLabel7.text = "5. 개인정보의 파기 절차 및 방법\n주인장은 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.\n가. 파기절차\n이용자가 회원가입 등을 위해 입력하신 정보는 목적이 달성된 후 별도의 DB 로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기됩니다. 별도 DB 로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 보유되는 이외의 다른 목적으로 이용되지 않습니다.\n나. 파기기한\n이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유 기간의 종료일로부터 30일 이내에 파기하며 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 30일 이내에 그 개인정보를 파기합니다.\n다. 파기방법\n종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기하며,\n라. 장기 미이용자의 개인정보 파기\n정보통신망법에 따라 회원가입 후 서비스 이용이 없는 고객 및 12개월 이상 로그인하지 않은 경우 해당 이용자 ID 및 개인정보를 유효기간 경과 후 즉시 파기하거나, 분리하여 보관합니다. 이러한 경우 위 12개월의 기간 도래 30일 전까지 회사는 이용자의 개인정보가 분리되어 저장, 관리되고 있다는 사실과 기간 만료일 및 해당 개인정보의 항목을 전자우편, 서면, 모사전송, 전화 또는 이와 유사한 방법 중 어느 하나의 방법으로 이용자에게 알려드립니다. 명시한 기한 내에 로그인 하지 않거나 서비스 이용이 없는 경우에는 회원자격을 상실시킬 수 있습니다. 이 경우, 회원 아이디를 포함한 회원의 개인정보 및 서비스 이용 정보는 파기, 삭제됩니다."
            contentLabel8.text = "6. 이용자 및 법정대리인의 권리와 그 행사방법\n주인장은 이용자 및 법정대리인의 권리를 다음과 같이 보호하고 있습니다.\n가. 언제든지 자신의 개인정보를 조회하고 수정할 수 있습니다.\n나. 언제든지 개인정보 제공에 관한 동의철회/회원가입 해지를 요청할 수 있습니다.\n다. 정확한 개인정보의 이용 및 제공을 위해 이용자가 개인정보 수정 진행 시 수정이 완료될 때까지 이용자의 개인정보는 이용되거나 제공되지 않습니다. 이미 제 3 자에게 제공된 경우에는 지체 없이 제공받은 자에게 사실을 알려 수정이 이루어질 수 있도록 하겠습니다.\n권리 행사는 juinjang1227@gmail.com을 통해서 할 수 있습니다."
            contentLabel9.text = "7. 개인정보에 관한 민원서비스\n주인장은 개인정보보호책임 업무를 맡고 있는 팀원을 배정하여 개인정보 처리방침의 이행사항을 준수하고 있습니다.\n관련 문의: juinjang1227@gmail.com"
            
            contentLabel2.asFont(targetString: "1. 총칙", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel3.asFont(targetString: "2. 개인정보의 처리목적", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel4.asFont(targetString: "3. 수집하는 개인정보의 항목", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel5.asFont(targetString: "4. 개인 정보의 위탁", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel7.asFont(targetString: "5. 개인정보의 파기 절차 및 방법", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel8.asFont(targetString: "6. 이용자 및 법정대리인의 권리와 그 행사방법", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            contentLabel9.asFont(targetString: "7. 개인정보에 관한 민원서비스", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
            
            contentLabel10.isHidden = true
            contentLabel11.isHidden = true
            // 이미지뷰들 숨기기
            imageView.isHidden = true
            imageView2.image = UIImage(named: "useImage4")
            imageView3.isHidden = true
            
            // 이미지뷰 높이를 0으로 설정하여 공간 제거
            imageView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            imageView2.snp.updateConstraints {
                $0.height.equalTo(210)
            }
            imageView3.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentLabel9.frame.maxY + 16)
        default:
            print("여기기기")
            break
        }
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func setConstraint() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(dropdownButton.snp.top).offset(-16)
        }
        dropdownButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(33)
            $0.height.equalTo(63)
        }
        dropdownImageView.snp.makeConstraints {
            $0.centerY.equalTo(dropdownButton)
            $0.right.equalTo(dropdownButton).inset(16)
            $0.width.height.equalTo(22)
        }
        dropdownTableView.snp.makeConstraints {
            $0.bottom.equalTo(dropdownButton.snp.top)  // 버튼 위로 테이블뷰가 나오도록 변경
            $0.left.right.equalTo(dropdownButton)
            $0.height.equalTo(0)  // 초기 높이는 0
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
        imageView.snp.makeConstraints {
            $0.top.equalTo(contentLabel3.snp.bottom)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
            $0.height.equalTo(130)
        }
        contentLabel4.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
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
        imageView3.snp.makeConstraints {
            $0.top.equalTo(contentLabel6.snp.bottom)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
            $0.height.equalTo(120)
        }
        contentLabel7.snp.makeConstraints {
            $0.top.equalTo(imageView3.snp.bottom).offset(4)
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
        }
        contentLabel10.snp.makeConstraints {
            $0.top.equalTo(contentLabel9.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        
        contentLabel11.snp.makeConstraints {
            $0.top.equalTo(contentLabel10.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        updateContent(forVersion: "이용약관 버전 1.1.0 (시행일 2025.01.12)")
        view.addSubview(scrollView)
        view.addSubview(dropdownButton)
        dropdownButton.addSubview(dropdownImageView)
        view.addSubview(dropdownTableView)
        
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        
        dropdownButton.addTarget(self, action: #selector(dropdownButtonTapped), for: .touchUpInside)
    
        scrollView.addSubview(contentLabel1)
        scrollView.addSubview(contentLabel2)
        scrollView.addSubview(contentLabel3)
        scrollView.addSubview(contentLabel4)
        scrollView.addSubview(contentLabel5)
        scrollView.addSubview(imageView)
        scrollView.addSubview(imageView2)
        scrollView.addSubview(imageView3)
        scrollView.addSubview(contentLabel6)
        scrollView.addSubview(contentLabel7)
        scrollView.addSubview(contentLabel8)
        scrollView.addSubview(contentLabel9)
        scrollView.addSubview(contentLabel10)
        scrollView.addSubview(contentLabel11)

        view.backgroundColor = .mainWhite
        setConstraint()
    }
}

extension Use2ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return versions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VersionCell", for: indexPath)
        cell.textLabel?.text = versions[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        cell.textLabel?.textColor = .gray450
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.preservesSuperviewLayoutMargins = false
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVersion = versions[indexPath.row]
        dropdownButton.setTitle(selectedVersion, for: .normal)
        updateContent(forVersion: selectedVersion)
        dropdownButtonTapped()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
