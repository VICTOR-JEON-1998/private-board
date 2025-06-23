import { NextApiRequest, NextApiResponse } from 'next';
import { prisma } from '@/lib/prisma';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const adminId = req.headers['x-user-id'];
  const { userId } = req.body;

  if (typeof adminId !== 'string' || !userId) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    // 관리자 여부 확인
    const adminUser = await prisma.user.findUnique({
      where: { id: adminId },
    });

    if (!adminUser || adminUser.role !== 'ADMIN' || !adminUser.groupId) {
      return res.status(403).json({ message: 'Not authorized' });
    }

    // 요청 유효성 확인
    const joinRequest = await prisma.groupJoinRequest.findFirst({
      where: {
        userId,
        groupId: adminUser.groupId,
        status: 'PENDING',
      },
    });

    if (!joinRequest) {
      return res.status(404).json({ message: 'Join request not found' });
    }

    // 요청 승인 및 유저 그룹 설정
    await prisma.$transaction([
      prisma.groupJoinRequest.update({
        where: { id: joinRequest.id },
        data: { status: 'APPROVED' },
      }),
      prisma.user.update({
        where: { id: userId },
        data: { groupId: adminUser.groupId },
      }),
    ]);

    return res.status(200).json({ message: 'Join request approved' });
  } catch (err) {
    console.error('❌ Approve error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
}
