import { NextApiRequest, NextApiResponse } from 'next';
import { prisma } from '../../../lib/prisma';
import { nanoid } from 'nanoid';
import { verifyToken } from '../../../lib/auth'; // 추가

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const decoded = verifyToken(req, res);
  if (!decoded) return; // 인증 실패 시 응답 종료

  const userId = decoded.sub as string;

  const { name } = req.body;
  if (!name || !userId) {
    return res.status(400).json({ message: 'Missing group name or user ID' });
  }

  try {
    const invitationCode = nanoid(6).toUpperCase();

    const group = await prisma.group.create({
      data: {
        name,
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
