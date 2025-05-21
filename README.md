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

---

## ✅ 2025-04-11 작업 기록

### 🔐 로그인 후 인증 유지 흐름 완성
- JWT 인증 토큰 검증 유틸 함수(`lib/verifyToken.ts`) 구현
- 인증된 사용자만 접근 가능한 API `/api/me` 생성
- Authorization 헤더(`Bearer <token>`)에서 토큰 추출 및 검증
- Prisma를 통해 해당 유저 정보 조회 후 응답
- Postman을 통해 정상 인증 테스트 성공

### 🧠 흐름 정리
1. 로그인 API로 JWT 토큰 발급
2. 토큰을 Authorization 헤더에 포함
3. `/api/me` API 호출 시 토큰 검증 → 유저 정보 반환


# Private Board Backend - Auth & Post API

## 📅 2025-04-17 작업일지


## ✅ 주요 작업 요약 (2025.04.16)

### 🔐 Auth 기능
- 회원가입 API (`POST /api/auth/signup`)
- 로그인 API (`POST /api/auth/login`)
- JWT 기반 인증 유지 API (`GET /api/me`)

### 📝 게시글 기능
- 게시글 작성 (`POST /api/posts`) ✅ 인증 필요
- 게시글 전체 조회 (`GET /api/posts`)
- 게시글 단일 조회 (`GET /api/posts/:id`)
- 게시글 수정 (`PUT /api/posts/:id`) ✅ 인증 필요
- 게시글 삭제 (`DELETE /api/posts/:id`) ✅ 인증 필요
- 🔐 본인 게시글만 수정/삭제 가능 (authorId 체크)

---
### ✅ 주요 완료 항목
- Flutter 프론트엔드에서 로그인 / 회원가입 / 인증 유지 기능 연동 완료
- 게시글 작성 / 전체 조회 / 단일 조회 기능 프론트 연동 완료
- 게시글 수정 / 삭제 기능 프론트 연동 완료
- `PostDetailPage`에 본인 글일 경우만 수정/삭제 버튼 보이도록 조건부 렌더링 구현
- Prisma 백엔드에서 `author.id` 포함되도록 쿼리 수정 (`findMany`, `findUnique`)

---

### 🐞 추후 확인 필요
- 현재 `currentUserId`가 null로 나오는 이슈 발생 → 본인 게시글임에도 수정/삭제 버튼이 비노출됨
- `/api/me` 호출 실패 또는 SharedPreferences에서 토큰 불러오기 실패 가능성 있음
- 다음 접속 시 콘솔 로그와 API 응답 디버깅 필요

---

### 💡 다음 작업 예정
- `PostDetailPage`에서 사용자 정보 동기화 문제 해결 (`currentUserId`)
- 댓글 기능 또는 좋아요 기능 중 선택하여 기능 확장 예정


# 2024-04-27 (토)

## ✅ 오늘 한 일

- **게시글/로그인 화면 자동 라우팅 로직 정상화**
  - 토큰 체크 후 라우팅, 무한로딩/401 문제 해결
- **이모지 공감 버튼(EmojiReactionRow) UI, 상태 관리 및 토글 로직 완성**
  - 단일 이모지 선택, 중복 방지, 클릭시 토글 등 프론트엔드 기능 구현
- **빌드 에러(Null-safety) 원인 및 해결**
  - `firstWhere`의 `orElse: () => null` → 빈 Map 반환 방식으로 수정
  - 빌드 에러 완전 해결

- **이모지 리액션 요청시 서버에서 500 에러 발생**
  - 프론트엔드 로직/요청까지는 정상 동작 확인
  - 서버 API(`/api/posts/[id]/reactions`)에서 Internal Server Error
  - API, DB, 인증 흐름 등 백엔드 쪽 점검 필요

---

## ❗ 남은 문제/내일 목표

- **서버(백엔드) `/api/posts/[id]/reactions` POST 상세 로깅 및 버그 수정**
- **프론트/백엔드 이모지 카운트 동기화 점검**
  - DB, Prisma, 인증 미들웨어 등 재확인

---

## 📝 추가 메모

- 프론트엔드 이슈(상태 관리, UI, 인증, 빌드)는 모두 해결!
- 서버 500 에러만 잡으면 완성도 급상승!



# 🛠️ 2025-05-13 - PB 프로젝트 이모지 리액션 디버깅 기록

## 1. 문제 현상

- 이모지를 눌러도 숫자(count)가 갱신되지 않음
- 선택한 이모지가 UI에서 표시되지 않음 (selectedEmojiKey == null)
- 서버에는 정상적으로 반영되고 있음 (200 OK 응답)

---

## 2. 원인 분석

- 클라이언트에서 서버 응답을 `emojiKey`가 아닌 `emoji`로 비교함
- selected 이모지를 식별할 때 `users.contains(id)` 방식으로 접근 (하지만 서버는 `userId`만 줌)
- POST 요청 후 `_loadReactions()`를 호출하지 않아 UI와 서버 상태 불일치 발생

---

## 3. 해결 내용

### ✅ 3.1 count 비교 키 수정

```dart
// before
final idx = emojiList.indexWhere((em) => em['key'] == e['emoji']);

// after
final idx = emojiList.indexWhere((em) => em['key'] == e['emojiKey']);
if (idx != -1) {
  emojiList[idx]['count'] = (emojiList[idx]['count'] ?? 0) + 1;
}
```

### ✅ 3.2 선택 이모지 판별 로직 수정

```dart
// before
selectedEmojiKey = reactions.firstWhere(
  (e) => (e['users'] as List?)?.contains(currentUserId) ?? false,
  orElse: () => null,
)?['emoji'];

// after
selectedEmojiKey = reactions.firstWhere(
  (e) => e['userId'] == currentUserId,
  orElse: () => null,
)?['emojiKey'];
```

### ✅ 3.3 POST 후 상태 재동기화

```dart
await PostApi.reactToPost(postId, emojiKey);
await _loadReactions(); // 화면을 서버와 동기화
```

---

## 4. 결과

- ✅ 이모지 count 실시간 반영됨
- ✅ 선택된 이모지도 정상 표시됨
- ✅ 서버 상태와 UI 정합성 유지 완료

---

## 5. 오늘의 교훈

- 프론트와 백엔드 데이터 구조가 정확히 일치해야 한다
- 식별자 기반 비교는 데이터 정합성의 핵심이다
- 상태 기반 UI에서는 비동기 작업 후 재로드가 매우 중요하다


# 📦 2025-05-14 - 그룹 모델 도입 및 마이그레이션 완료

## ✅ 주요 작업 요약

### 1. Prisma 모델 업데이트
- `Group` 모델 신규 생성 (id, name, invitationCode, hasAdmin, createdAt)
- `User` 모델에 `groupId`, `role` 필드 추가 (`role`은 enum: USER / ADMIN)
- `Post` 모델에 `groupId` 필드 추가

### 2. 마이그레이션 이슈 해결
- 기존 Post 데이터가 존재해 `groupId` NOT NULL 제약이 오류 발생
- 해결:
  - `Group` 테이블을 먼저 생성
  - 기본 그룹 레코드 삽입 (`id: '0000...'`)
  - `Post.groupId`에 default 값으로 지정
  - 외래키 및 인덱스 설정

### 3. 결과
- 마이그레이션 성공 (`npx prisma migrate dev`)
- Prisma Client 재생성 완료
- 그룹 기반 기능 개발의 토대 확보

---

## 🧠 향후 예정 작업

- 그룹 생성 API
- 초대 코드 기반 그룹 참여 API
- 관리자 기반 글/익명 분기 처리

# ✅ Private Board Ver5 - 2025-05-21 작업 기록

## 🎯 오늘의 목표
그룹(Group) 생성/참여 기능을 위한 백엔드 + API 연동 테스트 기반 구축

---

## 📁 프로젝트 구조 요약

- `private_board_backend`: Next.js 기반 백엔드 (API Routes)
- `private_board_frontend`: Flutter 기반 프론트엔드

---

## ✅ 오늘 작업 정리

### 1️⃣ 백엔드 API 경로 오류 디버깅

- 문제: `/groups/create` 요청 시 404 오류 발생
- 원인: `pages/api/groups/create.ts` 파일이 존재하지 않음 (Next.js는 파일 기반 라우팅)
- 해결: `create.ts` 파일 새로 생성하여 API 경로 인식되도록 처리

---

### 2️⃣ 그룹 생성 API 구현 (Dummy Version)

#### 📄 경로
```
/private_board_backend/pages/api/groups/create.ts
```

#### 📄 코드 예시
```ts
import { NextApiRequest, NextApiResponse } from 'next';

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const { name, hasAdmin } = req.body;

  if (!name || hasAdmin === undefined) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  // TODO: Prisma 연동 예정
  return res.status(200).json({
    groupId: 'dummy-group-id',
    invitationCode: 'dummy-invite-code',
  });
}
```

---

### 3️⃣ Postman 테스트 흐름 완료

#### ✅ 테스트 흐름:

1. `POST /api/auth/register` – 회원가입
2. `POST /api/auth/login` – 로그인 & accessToken 발급
3. `POST /api/groups/create`
  - Header: `Authorization: Bearer <token>`
  - Body: `{ "name": "test group", "hasAdmin": true }`
  - ✅ 응답 성공 (200 OK) 확인

---

## 🧭 다음 작업 예정 (내일)

1. ✅ Prisma 연동된 실질적인 그룹 생성 로직
2. ✅ `/api/groups/join.ts` – 초대코드 기반 그룹 참여 API 구현
3. ✅ `User.groupId` 업데이트 로직
4. 🧪 Postman으로 그룹 참여까지 완성 테스트
5. 📱 Flutter와 API 연결 (JoinGroupPage → 실제 API 연결)
