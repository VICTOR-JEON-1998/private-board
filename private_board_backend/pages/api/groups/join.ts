import { NextApiRequest, NextApiResponse } from 'next';
import { prisma } from '@/lib/prisma';
import { getUserIdFromReq } from '@/lib/auth';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const { invitationCode } = req.body;
  if (!invitationCode) {
    return res.status(400).json({ message: '필수 정보가 누락되었습니다.' });
  }

  const userId = getUserIdFromReq(req);
  if (!userId) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  const group = await prisma.group.findUnique({
    where: { invitationCode },
  });

  if (!group) {
    return res.status(404).json({ message: '초대코드가 유효하지 않습니다.' });
  }

  await prisma.user.update({
    where: { id: userId },
    data: { groupId: group.id },
  });

  return res.status(200).json({
    message: '그룹에 성공적으로 참여했습니다.',
    groupName: group.name,
  });
}
