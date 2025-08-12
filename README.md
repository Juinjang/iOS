# 주인장 iOS

### 부동산 임장? 폰 하나면 충분해요. 
노트 쓰고 공유하고 필요한 정보는 바로 손에 주인장이랑 함께해요! 👋




[🔗 주인장 AppStore 설치 링크](https://apps.apple.com/kr/app/앱-아이디)

2. 앱 스토어/배포 링크 + 대표 스크린샷
	•	앱스토어 링크 / TestFlight 링크 (QR 코드도 가능)
	•	핵심 화면 3~5장만 (GIF 있으면 더 좋음, 기능별 설명은 필요 없음)





## 주요 기능

	•	한 줄 설명 + 이모지로 직관성 강화
	•	예:
	•	📦 상품 등록 – 판매자가 물건을 손쉽게 등록
	•	🔍 실거래가 비교 – 최근 거래가와 시세 비교
	•	💬 실시간 채팅 – 거래자 간 즉시 대화

 

## 팀 구성
### iOS Team
비모|유즈|
|:---:|:---:|
|<img src="이미지URL" width="300">|<img src="이미지URL" width="300">

### Server Team (다른 팀들도 필요할까요? 프로젝트 팀 구성에 대해 알고싶어하는 사람이 있다면, 저는 필요해보입니다.)

### Design Team

### PM Team


## 기술 스택

	•	iOS: Swift, ReactorKit, RxSwift, Tuist, Alamofire
	•	Server: Node.js, Express, MongoDB
	•	Tool: Figma, Notion, GitHub Actions

## 아키텍처 & 기술적 특징

	•	ReactorKit 기반 단방향 데이터 플로우
	•	Tuist로 모듈화 및 의존성 관리
	•	Firebase Crashlytics & Analytics 적용
	•	테스트 코드 작성 비율, CI/CD 적용 여부 (있다면 간단히 표기)

📌 여기서는 이유를 길게 쓰지 말고
“왜 이걸 썼는지”는 간단히 한 줄만 — 세부 설명은 WIKI나 문서로 분리

## 폴더 구조

📦 Jujinjang
 ┣ 📂 Presentation
 ┣ 📂 Domain
 ┣ 📂 Data
 ┣ 📂 Resources
 ┣ 📂 Support

## 문제 & 해결

개발 중 직면한 문제 & 해결 방법 (하이라이트 1~2개)
	•	문제: ReactorKit이 4년간 업데이트가 없어 Swift 최신 버전 호환성 우려
해결: 유지보수성 확보를 위해 모듈 단위로 추상화, 교체 가능 구조 설계
	•	문제: 서버 점검 모드 대응
해결: Firebase Remote Config 기반 BaseURL 동적 변경

## 설치/실행 방법
	•	만약 클론 후 실행 가능하다면, Xcode 버전, SPM 설치 방법 간단히

## WIKI 까지 작성 필요?


