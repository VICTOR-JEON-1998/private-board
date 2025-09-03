import type { NextApiRequest, NextApiResponse } from 'next';
import { prisma } from '../../../lib/prisma';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  try {
    if (req.method !== 'GET') {
      return res.status(405).json({ ok: false, error: 'Method not allowed' });
    }

    const raw = req.query.groupId;
    const groupIdRaw = Array.isArray(raw) ? raw[0] : raw;
    const groupId = (groupIdRaw ?? '').trim().toLowerCase();

    if (!groupId) {
      return res.status(400).json({ ok: false, error: 'Missing groupId' });
    }

    const existing = await prisma.group.findUnique({
      where: { groupId },
      select: { id: true },
    });

    return res.status(200).json({ ok: true, available: !existing });
  } catch (err) {
    console.error('[check-id][pages]', err);
    return res.status(500).json({ ok: false, error: 'Server error' });
  }
}
