import { NextApiRequest, NextApiResponse } from 'next';
import { prisma } from '../../../lib/prisma';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'GET') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const userId = req.query.userId as string | undefined;
  if (!userId) {
    return res.status(400).json({ message: 'Missing userId' });
  }

  try {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: { group: true },
    });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const groups = user.group ? [user.group] : [];
    return res.status(200).json({ groups });
  } catch (error) {
    console.error('❌ Fetch user groups error:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
}
