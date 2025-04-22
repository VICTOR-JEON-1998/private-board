import type { NextApiRequest, NextApiResponse } from 'next'
import { PrismaClient } from '@prisma/client'
import jwt from 'jsonwebtoken'

const prisma = new PrismaClient()
const JWT_SECRET = process.env.JWT_SECRET || 'default_secret'

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method === 'POST') {
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'No token provided' })
    }

    const token = authHeader.split(' ')[1]
    let userId: string

    try {
      const decoded = jwt.verify(token, JWT_SECRET) as { userId: string }
      userId = decoded.userId
    } catch (err) {
      return res.status(401).json({ message: 'Invalid token' })
    }

    const { title, content } = req.body
    if (!title || !content) return res.status(400).json({ message: 'Missing fields' })

    try {
      const post = await prisma.post.create({
        data: {
          title,
          content,
          authorId: userId,
        }
      })

      return res.status(201).json(post)
    } catch (err) {
      return res.status(500).json({ message: 'Failed to create post', error: err })
    }
  }

  // ✅ GET /api/posts
  if (req.method === 'GET') {
    try {
      const posts = await prisma.post.findMany({
        orderBy: { createdAt: 'desc' },
        include: {
          author: {
            select: {
              id: true,       // ✅ 추가!
              email: true,
            },
          },
        },
      });


      return res.status(200).json(posts)
    } catch (err) {
      return res.status(500).json({ message: 'Failed to fetch posts', error: err })
    }
  }

  return res.status(405).json({ message: 'Method Not Allowed' })
}
