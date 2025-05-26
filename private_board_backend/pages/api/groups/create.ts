import { NextApiRequest, NextApiResponse } from 'next';
import { prisma } from '../../../lib/prisma.ts';
import { nanoid } from 'nanoid'; // 초대코드 생성용

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const { name } = req.body;
  const userId = req.headers['x-user-id'];

  if (!name || typeof userId !== 'string') {
    return res.status(400).json({ message: 'Missing group name or user ID' });
  }

  try {
    // 초대코드 생성 (6자리 영문+숫자)
    const invitationCode = nanoid(6).toUpperCase();

    // 그룹 생성
    const group = await prisma.group.create({
      data: {
        name,
        invitationCode,
        hasAdmin: true,
      },
    });

    // 그룹 생성자 = 관리자 + 자동 참여 처리
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
