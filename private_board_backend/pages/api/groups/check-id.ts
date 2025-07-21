import { NextApiRequest, NextApiResponse } from 'next'
import { prisma } from '../../../lib/prisma'

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'GET') {
    return res.status(405).json({ message: 'Method not allowed' })
  }

const groupId = req.query.groupId;
if (!groupId || typeof groupId !== 'string') {
  return res.status(400).json({ message: 'Missing groupId' });
}

try {
  const existing = await prisma.group.findUnique({
    where: { loginId: groupId }, // ✅ 여기!
  });

  return res.status(200).json({ available: !existing });
} catch (error) {
  console.error('check-id error', error);
  return res.status(500).json({ message: 'Internal server error' });
}

}
