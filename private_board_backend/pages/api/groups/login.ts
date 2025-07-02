import { NextApiRequest, NextApiResponse } from 'next'
import { prisma } from '../../../lib/prisma'
import bcrypt from 'bcryptjs'

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' })
  }

  const { loginId, password } = req.body
  const userId = req.headers['x-user-id']

  if (!loginId || !password || typeof userId !== 'string') {
    return res.status(400).json({ message: 'Missing credentials or userId' })
  }

  try {
    const group = await prisma.group.findUnique({ where: { loginId } })
    if (!group) {
      return res.status(404).json({ message: 'Group not found' })
    }

    const match = await bcrypt.compare(password, group.password)
    if (!match) {
      return res.status(401).json({ message: 'Invalid password' })
    }

    await prisma.user.update({
      where: { id: userId },
      data: { groupId: group.id },
    })

    return res.status(200).json({ message: 'Joined group', groupName: group.name })
  } catch (error) {
    console.error('group login error', error)
    return res.status(500).json({ message: 'Internal server error' })
  }
}
