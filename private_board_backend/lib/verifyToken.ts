// lib/verifyToken.ts
import { verifyJwt } from './auth'

export function verifyToken(token: string | undefined): { userId: string, email?: string } | null {
  if (!token) {
    return null
  }

  const decoded = verifyJwt(token)
  if (!decoded) {
    return null
  }

  const userId = decoded.sub ?? decoded.userId

  if (!userId) {
    return null
  }

  return { userId, email: decoded.email }
}
