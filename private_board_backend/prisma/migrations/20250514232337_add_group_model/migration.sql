-- CreateEnum
CREATE TYPE "Role" AS ENUM ('USER', 'ADMIN');

-- ✅ 1. 그룹 테이블 먼저 생성
CREATE TABLE "Group" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "invitationCode" TEXT NOT NULL,
    "hasAdmin" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Group_pkey" PRIMARY KEY ("id")
);

-- ✅ 2. 기본 그룹 추가
INSERT INTO "Group" ("id", "name", "invitationCode", "hasAdmin", "createdAt")
VALUES ('00000000-0000-0000-0000-000000000001', '기본 그룹', 'default-code', false, CURRENT_TIMESTAMP);

-- ✅ 3. Post 테이블에 groupId 추가
ALTER TABLE "Post" ADD COLUMN "groupId" TEXT NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';

-- ✅ 4. User 테이블 변경
ALTER TABLE "User"
ADD COLUMN "groupId" TEXT,
ADD COLUMN "role" "Role" NOT NULL DEFAULT 'USER';

-- ✅ 5. 인덱스 및 외래키
CREATE UNIQUE INDEX "Group_invitationCode_key" ON "Group"("invitationCode");

ALTER TABLE "User"
ADD CONSTRAINT "User_groupId_fkey"
FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "Post"
ADD CONSTRAINT "Post_groupId_fkey"
FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
