# 프로젝트 소개
## 주인장 iOS - 부동산 매물 기록

<img width="500" alt="썸네일" src="https://github.com/user-attachments/assets/c4f9ce2e-5007-429c-bc4a-e39576f4c30f" />

### 부동산 임장? 폰 하나면 충분해요. 
방문한 부동산 임장 노트 쓰고 공유하고 필요한 정보는 바로 손에 주인장이랑 함께해요! 👋


<br>

### 📌 주인장 iOS App Store 링크
[![Download on the App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://apps.apple.com/kr/app/%EC%A3%BC%EC%9D%B8%EC%9E%A5-%EB%B6%80%EB%8F%99%EC%82%B0-%EB%A7%A4%EB%AC%BC-%EA%B8%B0%EB%A1%9D/id6605941969) 


<br>

# 주요 기능

	•	한 줄 설명 + 이모지로 직관성 강화
	•	예:
	•	📦 상품 등록 – 판매자가 물건을 손쉽게 등록
	•	🔍 실거래가 비교 – 최근 거래가와 시세 비교
	•	💬 실시간 채팅 – 거래자 간 즉시 대화

 

# 팀 구성
## iOS Team
비모|유즈|
|:---:|:---:|
|<img src="이미지URL" width="300">|<img src="이미지URL" width="300">

## Server Team (다른 팀들도 필요할까요? 프로젝트 팀 구성에 대해 알고싶어하는 사람이 있다면, 저는 필요해보입니다.)

## Design Team

## PM Team


# 기술 스택

	•	iOS: Swift, ReactorKit, RxSwift, Tuist, Alamofire
	•	Server: Node.js, Express, MongoDB
	•	Tool: Figma, Notion, GitHub Actions

# 아키텍처 & 기술적 특징

	•	ReactorKit 기반 단방향 데이터 플로우
	•	Tuist로 모듈화 및 의존성 관리
	•	Firebase Crashlytics & Analytics 적용
	•	테스트 코드 작성 비율, CI/CD 적용 여부 (있다면 간단히 표기)

📌 여기서는 이유를 길게 쓰지 말고
“왜 이걸 썼는지”는 간단히 한 줄만 — 세부 설명은 WIKI나 문서로 분리

# 폴더 구조

📦 Jujinjang
 ┣ 📂 Presentation
 ┣ 📂 Domain
 ┣ 📂 Data
 ┣ 📂 Resources
 ┣ 📂 Support

# 문제 & 해결

개발 중 직면한 문제 & 해결 방법 (하이라이트 1~2개)
	•	문제: ReactorKit이 4년간 업데이트가 없어 Swift 최신 버전 호환성 우려
해결: 유지보수성 확보를 위해 모듈 단위로 추상화, 교체 가능 구조 설계
	•	문제: 서버 점검 모드 대응
해결: Firebase Remote Config 기반 BaseURL 동적 변경

# 설치/실행 방법
	•	만약 클론 후 실행 가능하다면, Xcode 버전, SPM 설치 방법 간단히

# WIKI 까지 작성 필요?


# 📌 추가 링크  
- [공식 홈페이지](https://juinjang-official.framer.website/?fbclid=PAQ0xDSwMIHRNleHRuA2FlbQIxMQABpyE1s-q9JcrXD3Smu4SqoIHAs6yXSE1JQYeiNLYCsY7FuaCYqZFv8bl8qilD_aem_drubxYLHApzeFxtVskzdzQ)  
- [팀 개발 블로그](https://juinjang-history.tistory.com/m/category/iOS%20Developer)  
- [인스타그램](https://www.instagram.com/official_juinjang?igsh=MWg2amNnZ3ZxeWM3Ng==)  
- [Threads](https://www.threads.com/@official_juinjang?igshid=NTc4MTIwNjQ2YQ==)
