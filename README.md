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


## ✅ 2025년 3월 26일 작업 정리 — Private Board Flutter 프로젝트

### 📌 오늘의 핵심 작업:

> 🔧 실제 API 없이도 Mock API 기반의 전체 글 작성/조회 흐름 완성
> 

---

### 🧱 구조 설계 및 구현

### ✅ 1. Mock API 기반 구조 설계 및 구성

- `PostApi` 클래스 생성 → 내부에 mock 리스트 사용
- `fetchPosts()` / `createPost()` 구현
- `FutureProvider`로 상태관리 (`postListProvider`)

### ✅ 2. HomePage 수정

- `ConsumerWidget`에서 `postListProvider` 사용
- `.when(data/loading/error)` 처리
- 작성된 글 리스트를 카드 형태로 표시

### ✅ 3. WritePage 수정

- 글 작성 시 `PostApi.createPost()` 호출
- 작성 후 `postListProvider` 무효화 → 리스트 새로고침
- 작성 완료 SnackBar + `Navigator.pop()` 처리






# Private Board Backend

Next.js 기반의 Flutter 앱 전용 백엔드 API 서버입니다.  
Prisma + PostgreSQL을 사용하며, RESTful API 구조로 인증 기능을 제공합니다.

---

## ✅ 2025-03-29 작업 기록

### 📦 초기 프로젝트 세팅
- `npx create-next-app`로 백엔드 전용 프로젝트 생성 (TypeScript 기반)
- ESLint 적용, Tailwind/App Router/Turbopack 제외
- import alias `@/*` 적용

### 🐳 Docker 기반 PostgreSQL 세팅
- `postgres:15` 이미지를 사용해 Docker로 로컬 DB 컨테이너 구성
- DB명: `private_board`, 사용자: `admin`, 비밀번호: `secret123`
- `.env` 파일에 `DATABASE_URL` 환경변수 등록

### 🧬 Prisma ORM 초기화
- `npx prisma init` 실행 후 `schema.prisma` 작성
- `User` 모델 정의:
  - `id`, `email`, `password`, `createdAt`
- `npx prisma migrate dev` 로 DB 마이그레이션 완료
- Prisma Client 자동 생성 완료

### 🔐 회원가입 API 구현
- `POST /api/auth/register`
- 기능:
  - 이메일, 비밀번호 입력값 검증
  - 중복 이메일 체크
  - `bcryptjs`로 비밀번호 해싱
  - Prisma로 유저 DB 저장
  - 유저 정보 응답 (id, email, createdAt)
- 테스트:
  - Postman으로 테스트 완료 (`201 Created` 응답 확인)

---

## 🧭 다음 작업 예정

- `POST /api/auth/login` API 구현
- 비밀번호 검증 및 JWT 발급
- Flutter 연동 고려한 토큰 기반 인증 처리

---

## 📌 커밋 예정 메시지


