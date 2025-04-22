import type { NextApiRequest, NextApiResponse } from 'next'
import { PrismaClient } from '@prisma/client'
import jwt from 'jsonwebtoken'

const prisma = new PrismaClient()
const JWT_SECRET = process.env.JWT_SECRET || 'default_secret'

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const { id } = req.query

  if (req.method === 'PUT') {
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
    if (!title || !content) {
      return res.status(400).json({ message: 'Missing title or content' })
    }
    // 🔐 권한 체크
    const existingPost = await prisma.post.findUnique({
      where: { id: String(id) }
    })

    if (!existingPost) {
      return res.status(404).json({ message: 'Post not found' })
    }

    if (existingPost.authorId !== userId) {
      return res.status(403).json({ message: 'Forbidden: Not your post' })
    }



    try {
      const post = await prisma.post.update({
        where: { id: String(id) },
        data: { title, content }
      })

      return res.status(200).json(post)
    } catch (err) {
      return res.status(500).json({ message: 'Failed to update post', error: err })
    }
  }

  if (req.method === 'DELETE') {
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
    // 🔐 권한 체크
    const existingPost = await prisma.post.findUnique({
      where: { id: String(id) }
    })

    if (!existingPost) {
      return res.status(404).json({ message: 'Post not found' })
    }

    if (existingPost.authorId !== userId) {
      return res.status(403).json({ message: 'Forbidden: Not your post' })
    }


    try {
      const deleted = await prisma.post.delete({
        where: { id: String(id) }
      })

      return res.status(200).json({ message: 'Post deleted', post: deleted })
    } catch (err) {
      return res.status(500).json({ message: 'Failed to delete post', error: err })
    }
  }

  if (req.method === 'GET') {
    try {
      const post = await prisma.post.findUnique({
        where: { id: req.query.id as string },
        include: {
          author: {
            select: {
              id: true,       // ✅ 반드시 포함!
              email: true,
            },
          },
        },
      });


      if (!post) {
        return res.status(404).json({ message: 'Post not found' })
      }

      return res.status(200).json(post)
    } catch (err) {
      return res.status(500).json({ message: 'Failed to fetch post', error: err })
    }
  }


  return res.status(405).json({ message: 'Method Not Allowed' })
}
