import { NextApiRequest, NextApiResponse } from 'next';
import { prisma } from 'private_board_backend/prisma'; // 경로 수정됨

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const { invitationCode } = req.body;
  const userId = req.headers['x-user-id']; // 추후 JWT 파싱으로 교체 예정

  if (!invitationCode || !userId) {
    return res.status(400).json({ message: '필수 정보가 누락되었습니다.' });
  }

  const group = await prisma.group.findUnique({
    where: { invitationCode },
  });

  if (!group) {
    return res.status(404).json({ message: '초대코드가 유효하지 않습니다.' });
  }

  const user = await prisma.user.update({
    where: { id: String(userId) },
    data: { groupId: group.id },
  });

  return res.status(200).json({
    message: '그룹에 성공적으로 참여했습니다.',
    groupName: group.name,
  });
}
