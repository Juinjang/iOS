//
//  UseViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/10/24.
//

import UIKit
import Then
import SnapKit

final class Use1ViewController : BaseViewController {
   private let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.indicatorStyle = .black
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .gray100
    }
    
    private let contentLabel1 = UILabel().then {
        $0.text = "제1장 총칙"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let contentLabel3 = UILabel().then {
        $0.text = "제 1조(목적)\n 이 약관은 주인장이 제공하는 주인장서비스(이하 “서비스”라 합니다)와 관련하여, 주인장과 이용 고객 간에 서비스의 이용조건 및 절차, 주인장은 회원의 관리, 의무 및 기타 필요한 사항을 규정함을 목적으로 합니다. 본 약관은 스마트폰(아이폰 등) 앱 등을 이용하는 전자상거래에 대해서도 그 성질에 반하지 않는 한 준용됩니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel4 = UILabel().then {
        $0.text = "제 2조(용어의 정리)\n1. 이 약관에서 사용하는 용어의 정의는 다음과 같습니다.\n - “서비스”란, 주인장이 제공하는 모든 서비스 및 기능을 말합니다.\n - “이용자”란, 이 약관에 따라 서비스를 이용하는 회원 및 비회원을 말합니다.\n - “회원”이란, 서비스 회원 등록을 하고 서비스를 이용하는 자를 말합니다.\n - “임장노트”이란, 서비스에 게재된 매물 정보리스트를 말합니다.\n - “체크리스트”란, 서비스의 기능 중 하나로 사용자가 임장 기록을 위해 체크하는 리스트를 말합니다.\n - “기록룸”이란, 서비스의 기능 중 하나로 녹음 파일, 메모장, stt 변환 내용이 포함됩니다.\n - “로그 기록”이란, 이용자의 통신 기기에서 수집된 유저 에이전트, ADID 등을 말합니다.\n - “계정”이란, 이용계약을 통해 생성된 회원의 고유 아이디와 이에 수반하는 정보를 말합니다.\n - “관련법”이란, 정보통신망 이용 촉진 및 정보보호 등에 관한 법률, 전기통신사업법, 개인정보보호법 등을 관련 있는 국내 법령을 말합니다.\n2. 제1항에서 정의되지 않은 이 약관 내 용어의 의미는 일반적인 이용 관행에 의합니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel5 = UILabel().then {
        $0.text = "제 3조(약관 등의 명시와 설명 및 개정)\n1. 주인장은 이 약관을 서비스 초기화면, 회원가입 회면 및 \"내 정보\"메뉴 등에 게시하거나 기타의 방법으로 회원에게 공지합니다.\n2. 주인장은 필요하다고 인정되는 경우, 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.\n3. 주인장은 약관을 개정할 경우, 적용 일자 및 개정 사유를 명시하여 현행약관과 함께 개정약관 적용 일자 7일전부터 “공지사항”을 통해 공지합니다. 다만, 개정 내용이 회원의 권리 및 의무에 중대한 영향을 미치는 경우에는 적용 일자 30일 전부터 회원의 연락처 또는 서비스 내부 알림 수단으로 개별 공지합니다.\n4. 회원은 개정 약관에 동의하지 않을 경우, 제 7조(서비스 이용 계약의 종료)에 따른 회원 탈퇴 방법으로 거부 의사를 표시할 수 있습니다. 단, 주인장 약관 개정 시 “개정 약관의 적용일자까지 회원이 거부 의사를 표시하지 아니할 경우 약관의 개정에 동의한 것으로 간주한다”는 내용을 고지하였음에도 불구하고 회원이 약관 개정에 대한 거부 의사를 표시하지 아니하면, 주인장은 적용 일자부로 개정 약관에 동의한 것으로 간주합니다.\n5. 회원은 약관 일부분만을 동의 또는 거부할 수 없습니다.\n6. 주인장은 제1항부터 제4항까지 준수하였음에도 불구하고 회원이 약관 개정 사실을 알지 못함으로써 발생한 피해에 대해 주인장의 고의 또는 중대한 과실이 없는 한 어떠한 책임도 지지 않습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel6 = UILabel().then {
        $0.text = "제 4조(서비스의 제공)\n1. 주인장은 다음 서비스를 제공합니다.\n - 임장 체크리스트 및 기록용 툴 서비스\n - 음성 변환 서비스\n - 기타 주인장이 정하는 서비스\n2. 주인장은 운영상, 기술상의 필요에 따라 제공하고 있는 서비스를 변경할 수 있습니다.\n3. 주인장은 이용자의 개인정보 및 서비스 이용 기록에 따라 서비스 이용에 차이를 둘 수 있습니다.\n4. 주인장은 설비의 보수, 교체, 점검 또는 기간 통신업자의 서비스 중지, 인터넷 장애 등의 사유로 인해 일시적으로 서비스 제공이 어려울 경우, 통보 없이 일시적으로 서비스 제공을 중단할 수 있습니다.\n5. 주인장은 천재지변, 전쟁, 경영 악화 등 불가항력적인 사유로 인해 서비스를 더 이상 제공하기 어려울 경우, 통보 없이 서비스 제공을 영구적으로 중단할 수 있습니다.\n6. 주인장공은 제4항부터 제6항까지 및 다음 내용으로 인해 발생한 피해에 대해 주인장의 고의 또는 중대한 과실이 없는 한 어떠한 책임도 지지 않습니다.\n - 모든 서비스, 게시물, 이용 기록의 진본성, 무결성, 신회성, 이용가능성의 보장\n - 서비스 이용 중 타인과 상호 간에 합의한 내용\n - 녹음 기록\n - 게시물, 광고의 버튼, 하이퍼링크 등 외부로 연결된 서비스와 같이 주인장이 제공하지 않은 서비스에서 발생한 피해\n - 주인장이 관련 법령에 따라 요구되는 보호조치를 이행하였음에도 불구하고, 네트워크의 안정성을 해치는 행위 또는 악성 프로그램 등에 의하여 발생하는 에기치 못한 이용자의 피해\n - 이용자의 귀책 사유 또는 주인장의 귀책 사유가 아닌 사유로 발생한 이용자의 피해"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel7 = UILabel().then {
        $0.text = "제 5조(서비스 이용계약의 성립)\n1. 주인장과 회원의 서비스 이용계약은 서비스를 이용하고자 하는 자(이하 “가입 신청자”라고 합니다)가 서비스 내부의 회원 가입 양식에 따라 필요한 회원정보를 기입하고, 이 약관, 개인정보 수집 및 이용 동의 등에 명시적인 동의를 한 후, 신청한 회원가입 의사 표시(이하 “이용신청”이라 합니다)를 주인장은 승낙함으로써 체결됩니다.\n2. 제1항의 승낙은 신청순서에 따라 순차적으로 처리되며, 회원가입의 성립 시기는 주인장은의 회원가입이 완료되었음을 알리는 승낙의 통지가 회원에게 도달하거나, 이에 준하는 권한이 회원에게 부여되는 시점으로 합니다.\n3. 주인장은 만 14세 미만 이용자의 이용신청을 금지하고 있습니다. 가입 신청자는 이용신청 시 만 14세 이상에 해당한다는 항목에 명시적인 동의를 함으로써 회원은 만 14세 이상임을 진술하고 보증합니다.\n4. 주인장은 가입 신청자의 이용신청에 있어 다음 각 호에 해당하는 경우, 이용신청을 영구적으로 승낙하지 않거나 유보할 수 있습니다.\n - 주인장공이 정한 이용신청 요건에 충족되지 않을 경우\n - 가입 신청자가 만 14세 미만인 경우\n - 제12조(금지행위)에 해당하는 행위를 하거나 해당하는 행위를 했던 이력이 있을 경우\n - 주인장의 기술 및 설비 상 서비스를 제공할 수 없는 경우\n - 기타 주인장이 합리적인 판단에 의하여 필요하다고 인정하는 경우\n5. 주인장은 제3항부터 제5항까지로 인해 발생한 피해에 대해 주인장의 고의 또는 중대한 과실이 없는 한 어떠한 책임도 지지 않습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel8 = UILabel().then {
        $0.text = "제 6조(개인정보의 관리 및 보호)\n1. 주인장은 관계 법령이 정하는 바에 따라 회원의 개인정보를 보호하기 위해 노력합니다. 개인정보의 보호 및 이용에 관해서는 관련 법령 및 주인장의 개인정보 처리방침을 따릅니다.\n2. 주인장은 개인정보에 변동이 있을 경우, 즉시 “내 정보”메뉴 및 문의 창구를 이용하여 정보를 최신화해야 합니다.\n3. 회원의 아이디, 비밀번호, 이메일, 대학생 정보 등 모든 개인 정보의 관리책임은 본인에게 있으므로, 타인에게 양도 및 대여할 수 없으며 유출되지 않도록 관리해야 합니다. 만약 본인의 아이디 및 비밀번호를 타인이 사용하고 있음을 인지했을 경우, 즉시 문의 창구로 알려야 하고, 안내가 있는 경우 이에 따라야 합니다.\n4. 주인장 회원이 제2항과 제3항을 이행하지 않아 발생한 피해에 대해, 주인장의 고의 또는 중대한 과실이 없는 한 어떠한 책임도 지지 않습니다.라도 로그인을 하는 경우 이용자의 동의에 따라 휴면계정을 복원하여 정상적인 서비스를 이용할 수 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel9 = UILabel().then {
        $0.text = "제 7조(서비스 이용계약의 종료)\n1. 주인장은 언제든지 본인의 계정으로 로그인한 뒤 서비스 내부의 “탈퇴하기”버튼을 누르는 방법으로 탈퇴를 요청할 수 있으며, 그 외 문의 창구 등을 통한 탈퇴 요청은 처리되지 않습니다. 주인장은 해당 요청을 확인한 후 탈퇴를 처리합니다.\n2. 주인장은 회원이 제12조(금지행위)에 해당하는 행위를 하거나 해당하는 행위를 했던 이력이 있을 경우, 제 13조(서비스 제공의 중단 및 서비스 이용계약의 해지)에 따라 서비스 제공을 중단하거나 서비스 이용계약을 해지할 수 있습니다.\n3. 주인장은 제1항부터 제3항까지로 인해 발생한 피해에 대해 주인장의 고의 또는 중대한 과실이 없는 한 어떠한 책임도 지지 않습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel10 = UILabel().then {
        $0.text = "제 8조(회원에 대한 통지)\n1. 주인장은 회원에 대한  통지가 필요한 경우, 서비스 내부 알림 수단을 이용할 수 있습니다.\n2. 주인장은 회원 전체에 대한 통지의 경우 공지사항에 게시함으로써 전 항의 통지에 갈음할 수 있습니다. 단, 회원의 권리 및 의무에 중대한 영향을 미치는 사항에 대해서는 1항에 따릅니다.\n3. 주인장이 회원에게 “30일 이내에 의사를 표시하지 아니할 경우 동의한 것으로 간주한다”는 내용을 고지하였음에도 불구하고 회원이 의사를 표시하지 아니하면, 주인장 통지 내용에 동의한 것으로 간주합니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel11 = UILabel().then {
        $0.text = "제 9조(저작권의 귀속)\n1. 주인장은 유용하고 편리한 서비스를 제공하기 위해, 2023년 부터 서비스 및 서비스 내부의 기능(체크리스트, 녹음기록룸, STT기능 등)의 다양한 기능을 직접 설계 및 운영하고 있는 데이터베이스 제작자에 해당합니다. 주인장은 저작권 법에 따라 데이터 베이스 제작자는 복제건 및 전송권을 포함한 데이터베이스 전부에 대한 권리를 가지고 있으며, 이는 법률에 따라 보호를 받는 대상입니다. 그러므로 이용자는 데이터베이스 제작자인 주인장의 승인 없이 데이터베이스의 전부 또는 일부를 복제/배포/방송 또는 전송할 수 없습니다.\n2. 주인장은 작성한 게시물에 대한 권리는 주인장에 귀속되며, 회원이 작성한 게시물에 대한 권리는 회원에게 귀속됩니다.\n3. 주인장 서비스에 게시물을 작성하는 경우 해당 게시물은 서비스에 노출될 수 있고 필요한 범위 내에서 사용, 저장, 복제, 수정, 공중송신, 전시, 배포 등의 방식으로 해당 게시물을 이용할수 있도록 허락하는 전 세계적인 라이선스를 주인장에 제공하게 됩니다. 이 경우, 주인장은 저작권법을 준수하며 회원은 언제든지 문의 창구 및 서비스 내부의 관리 기능이 제공되는 경우에는 해당 관리 기능을 이용하여 가능한 범위에 한해 해당 게시물에 대한 삭제, 수정, 비공개 등의 조치를 취할 수 있습니다.\n4. 주인장은 제3항 이외의 방법으로 회원의 게시물을 이용할 경우, 해당 회원으로부터 개별적으로 명시적인 동의를 받아야 합니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel12 = UILabel().then {
        $0.text = "제 10조(게시물의 삭제 및 접근 차단)\n1. 누구든지 게시물로 인해 사생활 침해나 명예훼손 등 권리가 침해된 경우 주인장에 해당 게시물의 삭제 또는 반박내용의 게재를 요청할 수 있습니다. 이 때 주인장 해당 게시물을 삭제할 수 있으며, 만약 권리 침해 여부가 불분명하거나 당사자간 다툼이 예상될 경우에는 해당 게시물에 대한 접근을 20일간 임시적으로 차단하는 조치를 취할 수 있습니다.\n2. 주인장 제1항에 따라 회원의 게시물을 삭제하거나 접근을 임시적으로 차단하는 경우, 해당 게시물이 작성된 기록룸에 필요한 조치를 한 사실을 명시하고, 불가능한 사유가 없을 경우 이를 요청한 자와 해당 게시물을 작성한 회원에게 그 사실을 통지합니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel13 = UILabel().then {
        $0.text = "제 11조(광고의 게재 및 발신)\n1. 주인장은 서비스의 제공을 위해 서비스 내부에 광고를 게재할 수 있습니다.\n2. 주인장은 이용자의 이용 기록을 활용한 광고를 게재할 수 있습니다.\n3. 주인장은 회원이 광고성 정보 수신에 명시적으로 동의한 경우 회원이 동의한 수단을 통해 광고성 정보를 발신할 수 있습니다.\n4. 주인장은 광고 게재 및 동의된 광고성 정보의 발신으로 인해 발생한 피해에 대해 주인장의 고의 또는 중대한 과실이 없는한 어떠한 책임도 지지 않습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel14 = UILabel().then {
        $0.text = "제 12조(금지행위)\n1. 이용자는 다음과 같은 행위를 해서는 안됩니다.\n • 성적 도의관념에 반하는 행위\n  - 정보통신망 이용촉진 및 정보보호 등에 관한 법률에 따른 유해정보 유통 행위\n  - 전기통신사업법에 따른 불법촬영물등 유통 행위\n  - 청소년보호법에 따른 청소년유해매체물 유통 행위\n  - 방송통신심의위원회의 정보통신에 관한 심의규정에 따른 심의기준의 성적 도의관념에 반하는 행위\n  - 이용규칙 금지행위에 따른 불건전 만남, 유흥, 성매매 등 내용 유통 행위\n • 홍보/판매 행위\n  - 이 약관이 적용되는 서비스 및 기능과 동일하거나 유사한 서비스 및 기능에 대한 직/간접적 홍보 행위\n  - 서비스, 브랜드, 사잉트, 애플리케이션, 사업체, 단체등을 알리거나 가입, 방문을 유도하기 위한 직/간접적 홍보 행위\n • 개인정보 또는 계정 기만, 침해, 공유 행위\n  - 개인정보를 허위, 누락, 오기, 도용하여 작성하는 행위\n  - 타인의 개인정보 및 계정을 수집, 저장, 공개, 이용하는 행위\n  - 자신과 타인의 개인정보를 제3자에게 공개, 양도, 승계하는 행위\n  - 다중 계정을 생성 및 이용하는 행위\n  - 자신의 게정을 이용하여 타인의 요청을 이행하는 행위\n • 시스템 부정행위\n  - 프로그램, 스크립트, 봇을 이용한 서비스 접근 등 사람이 아닌 컴퓨팅 시스템을 통한 서비스 접근 행위\n  - API 직접 호출, 유저 에이전트 조작, 패킷 캡처, 비정상적인 반복 조회 및 요청 등 허가하지 않은 방식의 서비스의 이용 해우이\n  - 주인장의 모든 재산에 대한 침해 행위\n • 업무 방해 행위\n  - 서비스 관리자 또는 이에 준하는 자격을 허가없이 취득하여 권한을 행사하거나, 사칭하여 허위의 정보를 발설하는 행위\n • 기타 현행법에 어긋나거나 부적절하다고 판단되는 행위\n2. 이용자는 제1항에 기재된 내용 이외 이 약관과 커뮤니티 이용규칙에서 규정한 내용에 반하는 행위를 해서는 안됩니다.\n3. 이용자가 제1항에 해당하는 행위를 할 경우, 주인장은 이 약관 제13조(서비스 제공의 중단 및 서비스 이용계약의 해지)에 따라 서비스 제공을 중단하거나 서비스 이용계약을 해지할 수 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    private let contentLabel15 = UILabel().then {
        $0.text = "제 13조(재판권 및 준거법)\n1. 주인장과 이용자 간에 발생한 분쟁에 관한 소송은 민사소송법상의 관할 법원에 제소합니다.\n2. 주인장과 이용자 간에 제기된 소송에는 대한민국 법을 준거법으로 합니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let contentLabel16 = UILabel().then {
        $0.text = "제 14조(등록매물의 저작권)\n ① 회원의 모든 등록 매물 저작권은 회원에게 있으며, 등록한 매물의 저작권 침해를 비롯한 법적 책임은 회원 본인에게 있습니다.\n ② 회원은 매물에 대하여 사용료 없는 영구적인 사용권을 주인장에게 부여합니다. 주인장관리자는 회원이 탈퇴한 후에도 사용권을 가지며, 여기에는 매물의 복제, 전시, 배포, 편집, 2차적 저작물의 작성 권한 등이 포함됩니다. 또한 메물은 검색결과 내지 서비스 관련 프로모션 등에 노출될 수 있으며, 주인장관리자는 리뷰를 마케팅에 활용할 수 있습니다.\n ③ 주인장은 회원이 등록한 리뷰의 링크 또는 리뷰를 구성하는 콘텐츠 등을 각각 또는 결합하여 마케팅 등에 활용할 수 있습니다.\n ④ 주인장은 제공된 매물의 취지를 벗어나지 않는 정도의 편집, 수정, 가공 등을 할 수 있으며 출처의 표기를 제외할 수도 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    private let contentLabel17 = UILabel().then {
        $0.text = "제 15조(기타)\n1. 이 약관은 2024년 1월 26일에 개정되었습니다.\n2. 이 약관에도 불구하고, 주인장과 이용자가 이 약관의 내용과 다르게 합의한 사항이 있는 경우에는 해당 내용을 우선으로 합니다.\n3. 주인장이 필요한 경우 약관의 하위 규정을 정할 수 있으며, 이 약관과 하위 규정이 상충하는 경우에는 이 약관의 내용이 우선 적용됩니다.\n4. 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 관련법 또는 관례에 따릅니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
//MARK: - 함수
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "주인장 이용약관"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(named:"arrow-left"), style: .plain, target: self, action: #selector(tapCloseButton))
        closeButtonItem.tintColor = .gray450
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
//        contentLabel2.snp.makeConstraints {
//            $0.top.equalTo(contentLabel1.snp.bottom).offset(4)
//            $0.left.right.equalToSuperview().inset(16)
//            $0.width.equalTo(scrollView.snp.width).inset(16)
//        }
        contentLabel3.snp.makeConstraints {
            $0.top.equalTo(contentLabel1.snp.bottom).offset(4)
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
        }
        contentLabel17.snp.makeConstraints {
            $0.top.equalTo(contentLabel16.snp.bottom).offset(4)
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
        //scrollView.addSubview(contentLabel2)
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
        scrollView.addSubview(contentLabel17)
        contentLabel3.asFont(targetString: "제 1조(목적)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel4.asFont(targetString: "제 2조(용어의 정리)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel5.asFont(targetString: "제 3조(약관 등의 명시와 설명 및 개정)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel6.asFont(targetString: "제 4조(서비스의 제공)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel7.asFont(targetString: "제 5조(서비스 이용계약의 성립)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel8.asFont(targetString: "제 6조(개인정보의 관리 및 보호)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel9.asFont(targetString: "제 7조(서비스 이용계약의 종료)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel10.asFont(targetString: "제 8조(회원에 대한 통지)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel11.asFont(targetString: "제 9조(저작권의 귀속)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel12.asFont(targetString: "제 10조(게시물의 삭제 및 접근 차단)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel13.asFont(targetString: "제 11조(광고의 게재 및 발신)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel14.asFont(targetString: "제 12조(금지행위)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel15.asFont(targetString: "제 13조(재판권 및 준거법)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel16.asFont(targetString: "제 14조(등록매물의 저작권)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel17.asFont(targetString: "제 15조(기타)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        view.backgroundColor = .mainWhite
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

