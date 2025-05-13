import { NextApiRequest, NextApiResponse } from 'next'
import { PrismaClient } from '@prisma/client'
import { verifyToken } from '../../../../lib/verifyToken'

const prisma = new PrismaClient()



export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method Not Allowed' })
  }

  const emojiKeyToEmoji = {
    like: '👍',
    laugh: '😂',
    wow: '😮',
  };


  try {
    const token = req.headers.authorization?.split(' ')[1]
    const user = verifyToken(token)
    console.log('[DEBUG] user:', user);
    if (!user) return res.status(401).json({ message: 'Unauthorized' })

    const { emojiKey } = req.body
    const postId = req.query.id

    if (!emojiKey || !postId) {
      return res.status(400).json({ message: 'Missing parameters' })
    }

    const existing = await prisma.reaction.findFirst({
      where: {
        postId,
        userId: user.userId,
      },
    })

    if (existing) {
      if (existing.emojiKey === emojiKey) {
        await prisma.reaction.delete({ where: { id: existing.id } })
        return res.status(200).json({ message: 'Reaction removed' })
      } else {
        await prisma.reaction.update({
          where: { id: existing.id },
          data: { emojiKey },
        })
        return res.status(200).json({ message: 'Reaction updated' })
      }
    }

    await prisma.reaction.create({
      data: {
        postId,
        userId: user.userId,
        emojiKey,
        emoji: emojiKeyToEmoji[emojiKey],
      },
    });


    return res.status(201).json({ message: 'Reaction added' })
  } catch (error) {
    console.error('[REACTION_ERROR]', error)
    return res.status(500).json({ message: 'Internal server error' })
  }
    const user = verifyToken(token);
    console.log('[DEBUG] 사용자:', user);
    if (!user) return res.status(401).json({ message: 'Unauthorized' });


}