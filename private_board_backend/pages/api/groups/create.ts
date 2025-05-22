import { NextApiRequest, NextApiResponse } from 'next';

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const { name, hasAdmin } = req.body;

  if (!name || hasAdmin === undefined) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  // TODO: Prisma 연결 로직 추가 가능
  return res.status(200).json({
    groupId: 'dummy-group-id',
    invitationCode: 'dummy-invite-code',
  });
}
