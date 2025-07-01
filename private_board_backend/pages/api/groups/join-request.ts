import { NextApiRequest, NextApiResponse } from 'next';
import { prisma } from '@/lib/prisma'; // 실제 경로에 맞게 조정

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const { invitationCode, message } = req.body;
  const userId = req.headers['x-user-id'];

  if (!invitationCode || typeof userId !== 'string') {
    return res.status(400).json({ message: 'Missing invitationCode or userId' });
  }

  try {
    // 초대코드로 그룹 조회
    const group = await prisma.group.findUnique({
      where: { invitationCode },
    });

    if (!group) {
      return res.status(404).json({ message: 'Group not found' });
    }

    // 이미 요청했는지 확인
    const existing = await prisma.groupJoinRequest.findFirst({
      where: {
        userId,
        groupId: group.id,
        status: 'PENDING',
      },
    });

    if (existing) {
      return res.status(409).json({ message: 'Already requested to join this group' });
    }

    // 요청 생성
    const joinRequest = await prisma.groupJoinRequest.create({
      data: {
        userId,
        groupId: group.id,
        message,
      },
    });

    return res.status(201).json({
      message: 'Join request submitted',
      requestId: joinRequest.id,
    });
  } catch (error) {
    console.error('❌ Join request error:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
}
