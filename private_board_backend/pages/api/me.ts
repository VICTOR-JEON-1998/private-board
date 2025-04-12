// pages/api/me.ts

import type { NextApiRequest, NextApiResponse } from 'next'
import { PrismaClient } from '@prisma/client'
import { verifyToken } from '@/lib/verifyToken'

const prisma = new PrismaClient()

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'GET') {
    return res.status(405).json({ message: '허용되지 않은 메서드입니다.' })
  }

  const authHeader = req.headers.authorization

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: '인증 정보가 없습니다.' })
  }

  const token = authHeader.split(' ')[1]
  const decoded = verifyToken(token)

  if (!decoded || typeof decoded !== 'object' || !('userId' in decoded)) {
    return res.status(401).json({ message: '유효하지 않은 토큰입니다.' })
  }

  try {
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId as string },
      select: {
        id: true,
        email: true,
        createdAt: true,
      },
    })

    if (!user) {
      return res.status(404).json({ message: '유저를 찾을 수 없습니다.' })
    }

    return res.status(200).json({ user })
  } catch (error) {
    console.error('[ME_API_ERROR]', error)
    return res.status(500).json({ message: '서버 오류가 발생했습니다.' })
  }
}
