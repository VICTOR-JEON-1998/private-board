/*
  Warnings:

  - Added the required column `emojiKey` to the `Reaction` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Reaction" ADD COLUMN     "emojiKey" TEXT NOT NULL;
