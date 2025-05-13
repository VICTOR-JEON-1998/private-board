// lib/verifyToken.ts
import jwt from 'jsonwebtoken'
import { JwtPayload } from 'jsonwebtoken'

const JWT_SECRET = process.env.JWT_SECRET || 'default_secret'

export function verifyToken(token: string): { userId: string, email: string } | null {
  try {
    const decoded = jwt.verify(token, JWT_SECRET) as JwtPayload
    return { userId: decoded.sub as string, email: decoded.email }
  } catch (error) {
    return null
  }
}
