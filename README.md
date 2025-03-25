2025년 3월 24일 한 것

- 라우팅 구조 설계
    - 구조는 위 그래프대로 생성함
    - 스크립트를 사용하여 라우팅 구조를 만들었음
- 리눅스 데스크탑 에뮬레이터 실행 환경 구축
    - 안드로이드 에뮬레이터보다 훨씬 나은 것 같음
- 앱 실행시 로딩중 화면 →로그인페이지 화면 까지의 흐름 설정 완료
- 현재 로그인 페이지 화면은 아래와 같음

![image](https://github.com/user-attachments/assets/1b045879-6877-4850-9b64-b0a8795ed633)


2025년 3월 25일 한 것

### ✅ 로그인 페이지 UI 고도화

- 부드러운 파스텔톤 배경 적용 (`#FFF6F0`)
- 아이디 / 비밀번호 입력창
- 로그인 버튼
- 따뜻한 환영 문구와 부드러운 UX 구성
![image](https://github.com/user-attachments/assets/3a7fb782-770d-4de9-9b9a-76f53fc04fb1)

### ✅ 로그인 → 홈 화면 라우팅 연결

- 로그인 버튼 클릭 시 `/home` 경로로 이동
- `Navigator.pushReplacementNamed()` 사용
![image](https://github.com/user-attachments/assets/7873413d-2d92-4ad8-9eee-3ae7678923a4)

### ✅ 홈 화면 UI 구성

- 환영 메시지 ("안녕하세요, 오늘도 반가워요 😊")
- Mock 게시글 리스트 (익명 작성자 + 내용 일부)
- 부드러운 카드 UI + 글쓰기 FAB 버튼
- `/write` 라우팅 연결까지 준비됨


## 2025-03-25 작업 정리: Private Board Flutter 프로젝트

### 📌 오늘 한 작업

- `Post` 모델 생성 (`lib/models/post.dart`)
- `PostProvider` 생성 (StateNotifier 기반 Riverpod 상태관리)
- `WritePage` 글쓰기 화면 구성
    - `TextField` + 작성 버튼 UI
    - 글 작성 시 Provider에 상태 저장
- `main.dart`에 `ProviderScope` 적용 → Riverpod 전역 사용 설정
- `HomePage`를 `ConsumerWidget`으로 리팩토링
    - `ref.watch(postProvider)`로 글 리스트 실시간 표시

