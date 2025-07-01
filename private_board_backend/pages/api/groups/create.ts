import { NextApiRequest, NextApiResponse } from 'next'
import { prisma } from '../../../lib/prisma'
import { nanoid } from 'nanoid'
import bcrypt from 'bcryptjs'
import { verifyToken } from '../../../lib/auth'

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const decoded = verifyToken(req, res);
  if (!decoded) return; // 인증 실패 시 응답 종료

  const userId = decoded.sub as string;

  const { name, loginId, password } = req.body
  if (!name || !loginId || !password || !userId) {
    return res.status(400).json({ message: 'Missing parameters' })
  }

  const existing = await prisma.group.findUnique({ where: { loginId } })
  if (existing) {
    return res.status(409).json({ message: 'Duplicate groupId' })
  }

  try {
    const invitationCode = nanoid(6).toUpperCase();
    const hashedPassword = await bcrypt.hash(password, 10)

    const group = await prisma.group.create({
      data: {
        name,
        loginId,
        password: hashedPassword,
        invitationCode,
        hasAdmin: true,
      },
    });

    await prisma.user.update({
      where: { id: userId },
      data: {
        groupId: group.id,
        role: 'ADMIN',
      },
    });

    return res.status(201).json({
      groupId: group.id,
      invitationCode: group.invitationCode,
    });
  } catch (error) {
    console.error('❌ Group creation error:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
}
