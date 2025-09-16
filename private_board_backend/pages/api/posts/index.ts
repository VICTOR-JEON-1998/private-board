import type { NextApiRequest, NextApiResponse } from 'next'
import { getTokenFromReq, verifyJwt } from '@/lib/auth'
import prisma from '@/lib/prisma'

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method === 'POST') {
    // 🔐 1. 토큰 검증
    const token = getTokenFromReq(req)
    if (!token) {
      return res.status(401).json({ message: 'No token provided' })
    }

    const decoded = verifyJwt(token)
    const userId = decoded?.sub ?? decoded?.userId
    if (!userId) {
      return res.status(401).json({ message: 'Invalid token' })
    }

    // 📦 2. 요청 필드 체크
    const { title, content, groupId } = req.body
    if (!title || !content || !groupId) {
      return res.status(400).json({ message: 'Missing fields' })
    }

    try {
      // 🔍 3. 유저가 해당 그룹 소속인지 확인
      const membership = await prisma.groupMember.findFirst({
        where: { groupId, userId },
      })

      if (!membership) {
        return res.status(403).json({ message: 'User is not a member of this group' })
      }

      // ✍️ 4. 글 생성
      const post = await prisma.post.create({
        data: {
          title,
          content,
          authorId: userId,
          groupId,
        }
      })

      return res.status(201).json(post)
    } catch (err) {
      console.error('❌ 글 생성 실패:', err)
      return res.status(500).json({ message: 'Failed to create post', error: err })
    }
  }

  // 📥 GET /api/posts
  if (req.method === 'GET') {
    const { groupId } = req.query

    try {
      const posts = await prisma.post.findMany({
        where: groupId ? { groupId: String(groupId) } : undefined,
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

      return res.status(200).json(posts)
    } catch (err) {
      console.error('❌ 게시글 조회 실패:', err)
      return res.status(500).json({ message: 'Failed to fetch posts', error: err })
    }
  }

  return res.status(405).json({ message: 'Method Not Allowed' })
}
