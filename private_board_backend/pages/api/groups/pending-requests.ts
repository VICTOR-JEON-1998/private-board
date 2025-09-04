import { NextApiRequest, NextApiResponse } from 'next';
import { prisma } from '@/lib/prisma'; // 경로 맞게 조정
import { getUserIdFromReq } from '@/lib/auth';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'GET') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const userId = getUserIdFromReq(req);
  if (!userId) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  try {
    // 관리자 확인
    const adminUser = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!adminUser || adminUser.role !== 'ADMIN' || !adminUser.groupId) {
      return res.status(403).json({ message: 'Not authorized' });
    }

    // 해당 그룹의 대기 중 요청 조회
    const pendingRequests = await prisma.groupJoinRequest.findMany({
      where: {
        groupId: adminUser.groupId,
        status: 'PENDING',
      },
      include: {
        user: {
          select: {
            id: true,
            email: true,
          },
        },
      },
    });

    return res.status(200).json({ pendingRequests });
  } catch (err) {
    console.error('❌ Fetch pending requests error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
}
