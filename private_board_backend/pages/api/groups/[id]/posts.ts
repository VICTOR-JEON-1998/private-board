import { NextApiRequest, NextApiResponse } from 'next';
import { prisma } from '@/lib/prisma';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const { id } = req.query;

  if (req.method !== 'GET') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  try {
    const posts = await prisma.post.findMany({
      where: { groupId: id as string },
      orderBy: { createdAt: 'desc' },
      include: {
        author: {
          select: {
            id: true,
            email: true,
          },
        },
      },
    });
    return res.status(200).json(posts);
  } catch (error) {
    console.error('❌ Group posts fetch error:', error);
    return res.status(500).json({ message: 'Failed to fetch posts' });
  }
}
