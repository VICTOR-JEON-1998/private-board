import { NextApiRequest, NextApiResponse } from 'next'
import { PrismaClient } from '@prisma/client'
import { verifyToken } from '../../../../lib/verifyToken'

const prisma = new PrismaClient()

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const postId = req.query.id as string

  // pages/api/posts/[id]/reactions.ts

  if (req.method === 'POST') {
    const { emoji } = req.body;
    const userId = ... // 토큰에서 추출

    // 1. 기존 내 reaction 찾기
    const existing = await prisma.reaction.findFirst({
      where: { postId: req.query.id as string, userId }
    });

    if (existing) {
      if (existing.emoji === emoji) {
        // 2. 같은 이모지면 → reaction 삭제 (공감 취소)
        await prisma.reaction.delete({ where: { id: existing.id } });
        res.status(200).json({ status: 'unreacted', emoji });
        return;
      } else {
        // 3. 다른 이모지면 → 기존 reaction 삭제, 새로운 이모지로 추가
        await prisma.reaction.delete({ where: { id: existing.id } });
        await prisma.reaction.create({
          data: {
            postId: req.query.id as string,
            userId,
            emoji,
          }
        });
        res.status(200).json({ status: 'reacted', emoji });
        return;
      }
    } else {
      // 4. 기존 reaction 없으면 → 새로운 reaction 추가
      await prisma.reaction.create({
        data: {
          postId: req.query.id as string,
          userId,
          emoji,
        }
      });
      res.status(200).json({ status: 'reacted', emoji });
      return;
    }
  }


  return res.status(405).json({ message: 'Method Not Allowed' })
}
