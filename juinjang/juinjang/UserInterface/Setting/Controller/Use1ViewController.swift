//
//  UseViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/10/24.
//

import UIKit
import Then
import SnapKit

class Use1ViewController : UIViewController {
   private let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.indicatorStyle = .black
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = UIColor(named: "100")
    }
    
    private let contentLabel1 = UILabel().then {
        $0.text = "주인장 이용약관"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let contentLabel2 = UILabel().then {
        $0.text = "개인정보처리방침 \n제정 2022. 8. 3., 시행 2022 8. 3. \n<주인장>(이하 '주인장')은 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel3 = UILabel().then {
        $0.text = "제1조(개인정보의 처리 목적) \n‘회사’는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다. \n① (홈페이지 회원가입 및 관리) 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지, 만14세 미만 아동의 개인정보 처리 시 법정대리인의 동의여부 확인, 각종 고지·통지, 고충처리 목적으로 개인정보를 처리합니다. \n② (민원사무 처리) 민원인의 신원 확인, 민원사항 확인, 사실조사를 위한 연락·통지, 처리결과 통보 목적으로 개인정보를 처리합니다. \n③ (재화 또는 서비스 제공) 물품배송, 서비스 제공, 콘텐츠 제공, 맞춤서비스 제공, 본인인증을 목적으로 개인정보를 처리합니다. \n④ (마케팅 및 광고에의 활용) 신규 서비스(제품) 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공 , 인구통계학적 특성에 따른 서비스 제공 및 광고 게재 , 서비스의 유효성 확인, 접속빈도 파악 또는 회원의 서비스 이용에 대한 통계 등을 목적으로 개인정보를 처리합니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel4 = UILabel().then {
        $0.text = "제2조(개인정보의 처리 및 보유 기간) \n① ‘회사’는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다. \n② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다. \n 1. 개인정보는 수집.이용에 관한 동의일로부터까지 위 이용목적을 위하여 보유, 이용됩니다. \n 2. 보유근거 : 개인화 콘텐츠 제공 \n 3.관련법령 : \n  1) 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년 \n  2) 대금결제 및 재화 등의 공급에 관한 기록 : 5년 \n  3) 계약 또는 청약철회 등에 관한 기록 : 5년"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel5 = UILabel().then {
        $0.text = "제3조(처리하는 개인정보의 항목) \n① ‘회사’는 다음의 개인정보 항목을 처리하고 있습니다. \n 1. 홈페이지 회원가입 및 관리 \n 2. 필수항목 : 이메일, 비밀번호, 로그인ID, 성별 \n 3. 선택항목 : 이메일, 휴대전화번호, 자택주소, 생년월일, 이름"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel6 = UILabel().then {
        $0.text = "제4조(만 14세 미만 아동의 개인정보 처리에 관한 사항) \n① ‘회사’는 만 14세 미만 아동에 대해 개인정보를 수집할 때 법정대리인의 동의를 얻어 해당 서비스 수행에 필요한 최소한의 개인정보를 수집합니다. \n 1. 필수항목 : 법정 대리인의 성명, 관계, 연락처 \n② 또한, 의 관련 홍보를 위해 아동의 개인정보를 수집할 경우에는 법정대리인으로부터 별도의 동의를 얻습니다. \n③ ‘회사’는 만 14세 미만 아동의 개인정보를 수집할 때에는 아동에게 법정대리인의 성명, 연락처와 같이 최소한의 정보를 요구할 수 있으며, 다음 중 하나의 방법으로 적법한 법정대리인이 동의하였는지를 확인합니다. \n 1. 동의 내용을 게재한 인터넷 사이트에 법정대리인이 동의 여부를 표시하도록 하고 개인정보처리자가 그 동의 표시를 확인했음을 법정대리인의 휴대전화 문자 메시지로 알리는 방법 \n 2. 동의 내용을 게재한 인터넷 사이트에 법정대리인이 동의 여부를 표시하도록 하고 법정대리인의 신용카드·직불카드 등의 카드정보를 제공받는 방법 \n 3. 동의 내용을 게재한 인터넷 사이트에 법정대리인이 동의 여부를 표시하도록 하고 법정대리인의 휴대전화 본인인증 등을 통해 본인 여부를 확인하는 방법 \n 4. 동의 내용이 적힌 서면을 법정대리인에게 직접 발급하거나, 우편 또는 팩스를 통하여 전달하고 법정대리인이 동의 내용에 대하여 서명날인 후 제출하도록 하는 방법 \n 5. 동의 내용이 적힌 전자우편을 발송하여 법정대리인으로부터 동의의 의사표시가 적힌 전자우편을 전송받는 방법 \n 6. 전화를 통하여 동의 내용을 법정대리인에게 알리고 동의를 얻거나 인터넷주소 등 동의 내용을 확인할 수 있는 방법을 안내하고 재차 전화 통화를 통하여 동의를 얻는 방법 \n 7. 그 밖에 위와 준하는 방법으로 법정대리인에게 동의 내용을 알리고 동의의 의사표시를 확인하는 방법"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel7 = UILabel().then {
        $0.text = "제5조(개인정보의 파기절차 및 파기방법) \n① ‘회사’는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다. \n② 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다. \n③ 개인정보 파기의 절차 및 방법은 다음과 같습니다. \n 1. (파기절차) ‘회사’는 파기 사유가 발생한 개인정보를 선정하고, ‘회사’의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel8 = UILabel().then {
        $0.text = "제6조(미이용자의 개인정보 파기 등에 관한 조치) \n① ‘회사’는 1년간 서비스를 이용하지 않은 이용자는 휴면계정으로 전환하고, 개인정보를 별도로 분리하여 보관합니다. 분리 보관된 개인정보는 1년간 보관 후 지체없이 파기합니다. \n② ‘회사’는 휴먼전환 30일 전까지 휴면예정 회원에게 별도 분리 보관되는 사실 및 휴면 예정일, 별도 분리 보관하는 개인정보 항목을 이메일, 문자 등 이용자에게 통지 가능한 방법으로 알리고 있습니다. \n③ ‘회사’는 휴면계정으로 전환을 원하지 않으시는 경우, 휴면계정 전환 전 서비스 로그인을 하시면 됩니다. 또한, 휴면계정으로 전환되었더라도 로그인을 하는 경우 이용자의 동의에 따라 휴면계정을 복원하여 정상적인 서비스를 이용할 수 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel9 = UILabel().then {
        $0.text = "제7조(정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항) \n① 정보주체는 ‘회사’에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다. \n② 제1항에 따른 권리 행사는 ‘회사’에 대해 「개인정보 보호법」 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 ‘회사’이에 대해 지체 없이 조치하겠습니다. \n③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다.이 경우 “개인정보 처리 방법에 관한 고시(제2020-7 호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다. \n④ 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다. \n⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다. \n⑥ ‘회사’는 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel10 = UILabel().then {
        $0.text = "제8조(개인정보의 안전성 확보조치에 관한 사항) \n‘회사’는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다. \n① (개인정보 취급 직원의 최소화 및 교육) 개인정보를 취급하는 직원을 지정하고 담당자에 한정시켜 최소화 하여 개인정보를 관리하는 대책을 시행하고 있습니다. \n② (해킹 등에 대비한 기술적 대책)‘회사’는 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신·점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적/물리적으로 감시 및 차단하고 있습니다. \n③ (개인정보의 암호화) 이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다. \n④ (접속기록의 보관 및 위변조 방지) 개인정보처리시스템에 접속한 기록을 최소 1년 이상 보관, 관리하고 있으며,다만, 5 만명 이상의 정보주체에 관하여 개인정보를 추가하거나, 고유식별정보 또는 민감정보를 처리하는 경우에는 2년이상 보관, 관리하고 있습니다. 또한, 접속기록이 위변조 및 도난, 분실되지 않도록 보안기능을 사용하고 있습니다. \n⑤ (개인정보에 대한 접근 제한) 개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel11 = UILabel().then {
        $0.text = "제9조(개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항) \n① ‘회사’는 이용자에게 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용합니다. \n② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다. \n 1. 쿠키의 사용 목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다. \n 2. 쿠키의 설치 운영 및 거부 : 웹브라우저 상단의 도구 >인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다. \n 3. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel12 = UILabel().then {
        $0.text = "제10조(행태정보의 수집·이용·제공 및 거부 등에 관한 사항)\n‘회사’온라인 맞춤형 광고 등을 위한 행태정보를 수집·이용·제공하지 않습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel13 = UILabel().then {
        $0.text = "제11조(추가적인 이용·제공 판단기준) \n‘회사’는 ‘개인정보 보호법’ 제15조 제3항 및 제17조 제4 항에 따라 ‘개인정보 보호법 시행령’ 제14조의2에 따른 사항을 고려하여 정보주체의 동의 없이 개인정보를 추가적으로 이용·제공할 수 있습니다. \n① 이에 따라 ‘회사’가 정보주체의 동의 없이 추가적인 이용·제공을 하기 위해서 다음과 같은 사항을 고려하였습니다. \n 1. 개인정보를 추가적으로 이용·제공하려는 목적이 당초 수집 목적과 관련성이 있는지 여부 \n 2. 개인정보를 수집한 정황 또는 처리 관행에 비추어 볼 때 추가적인 이용·제공에 대한 예측 가능성이 있는지 여부 \n 3. 개인정보의 추가적인 이용·제공이 정보주체의 이익을 부당하게 침해하는지 여부 \n 4. 가명처리 또는 암호화 등 안전성 확보에 필요한 조치를 하였는지 여부 \n※ 추가적인 이용·제공 시 고려사항에 대한 판단기준은 사업자/단체 스스로 자율적으로 판단하여 작성·공개함"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel14 = UILabel().then {
        $0.text = "제12조 (개인정보 보호책임자에 관한 사항) \n① 주인장은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다. \n▶ 개인정보 보호책임자 \n성명 : 여민경 \n연락처 : a54707226@gmail.com"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    private let contentLabel15 = UILabel().then {
        $0.text = "제13조(정보주체의 권익침해에 대한 구제방법) \n정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다. \n 1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr) \n 2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr) \n 3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr) \n 4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr) \n① 「개인정보보호법」 제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조( 개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다 \n※ 행정심판에 대해 자세한 사항은 중앙행정심판위원회(www.simpan.go.kr) 홈페이지를 참고하시기 바랍니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel16 = UILabel().then {
        $0.text = "제14조(개인정보 처리방침 변경) \n① 이 개인정보처리방침은 2023년 01월 18일부터 적용됩니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
//MARK: - 함수
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "주인장 이용약관"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(named:"arrow-left"), style: .plain, target: self, action: #selector(tapCloseButton))
        closeButtonItem.tintColor = UIColor(named: "300")
        closeButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = closeButtonItem
    }
    @objc func tapCloseButton() {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    func setConstraint() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(46)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(33)
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
        contentLabel6.snp.makeConstraints {
            $0.top.equalTo(contentLabel5.snp.bottom).offset(4)
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
        }
        contentLabel12.snp.makeConstraints {
            $0.top.equalTo(contentLabel11.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel13.snp.makeConstraints {
            $0.top.equalTo(contentLabel12.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel14.snp.makeConstraints {
            $0.top.equalTo(contentLabel13.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel15.snp.makeConstraints {
            $0.top.equalTo(contentLabel14.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel16.snp.makeConstraints {
            $0.top.equalTo(contentLabel15.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentLabel1)
        scrollView.addSubview(contentLabel2)
        scrollView.addSubview(contentLabel3)
        scrollView.addSubview(contentLabel4)
        scrollView.addSubview(contentLabel5)
        scrollView.addSubview(contentLabel6)
        scrollView.addSubview(contentLabel7)
        scrollView.addSubview(contentLabel8)
        scrollView.addSubview(contentLabel9)
        scrollView.addSubview(contentLabel10)
        scrollView.addSubview(contentLabel11)
        scrollView.addSubview(contentLabel12)
        scrollView.addSubview(contentLabel13)
        scrollView.addSubview(contentLabel14)
        scrollView.addSubview(contentLabel15)
        scrollView.addSubview(contentLabel16)
        contentLabel3.asFont(targetString: "제1조(개인정보의 처리 목적)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel4.asFont(targetString: "제2조(개인정보의 처리 및 보유 기간)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel5.asFont(targetString: "제3조(처리하는 개인정보의 항목)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel6.asFont(targetString: "제4조(만 14세 미만 아동의 개인정보 처리에 관한 사항)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel7.asFont(targetString: "제5조(개인정보의 파기절차 및 파기방법)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel8.asFont(targetString: "제6조(미이용자의 개인정보 파기 등에 관한 조치)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel9.asFont(targetString: "제7조(정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel10.asFont(targetString: "제8조(개인정보의 안전성 확보조치에 관한 사항)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel11.asFont(targetString: "제9조(개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel12.asFont(targetString: "제10조(행태정보의 수집·이용·제공 및 거부 등에 관한 사항)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel13.asFont(targetString: "제11조(추가적인 이용·제공 판단기준)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel14.asFont(targetString: "제12조 (개인정보 보호책임자에 관한 사항)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel15.asFont(targetString: "제13조(정보주체의 권익침해에 대한 구제방법)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel16.asFont(targetString: "제14조(개인정보 처리방침 변경)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        view.backgroundColor = .white
        setConstraint()
    }
}

//MARK: - Extension
extension UILabel {
    func asFont(targetString: String, font: UIFont) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedText = attributedString
    }
}

