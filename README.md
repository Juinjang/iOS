# 주인장 iOS
<img width="500" alt="썸네일" src="https://github.com/user-attachments/assets/6c4f7228-70f4-4de8-abda-391ce4436a40" />

### 부동산 임장? 폰 하나면 충분해요. 
노트 쓰고 공유하고 필요한 정보는 바로 손에 주인장이랑 함께해요! 👋



<p align="left">
  <img src="https://github.com/user-attachments/assets/84d36d58-b965-45f5-94e0-5c3998683a9f" width="9%" />
  <img src="https://github.com/user-attachments/assets/3bf08415-310a-4952-b4dd-bf79338f4007" width="9%" />
  <img src="https://github.com/user-attachments/assets/5ddd501d-2b90-4304-aa1f-8935acbf2b27" width="9%" />
  <img src="https://github.com/user-attachments/assets/0ce6c612-198b-43bf-8378-e2a1332d4900" width="9%" />
  <img src="https://github.com/user-attachments/assets/3f156bdb-42b2-4d08-a903-e986aef01af0" width="9%" />
  <img src="https://github.com/user-attachments/assets/bed1dc05-73ad-4de7-8582-852355e55d03" width="9%" />
  <img src="https://github.com/user-attachments/assets/177e67a6-6254-492e-9208-e740cf62a8ba" width="9%" />
  <img src="https://github.com/user-attachments/assets/bae7d9a9-90c3-421e-815e-a553f38c494a" width="9%" />
  <img src="https://github.com/user-attachments/assets/bcd05526-44ea-4a97-ad51-2c52c8072afb" width="9%" />
  <img src="https://github.com/user-attachments/assets/c5eee3ed-88cc-4220-95f5-49deb86c83ac" width="9%" />
</p>


[🔗 주인장 AppStore 설치 링크](https://apps.apple.com/kr/app/앱-아이디)



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


