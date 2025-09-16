import * as jwt from 'jsonwebtoken'

export interface JwtPayload {
  userId?: string
  sub?: string
  email?: string
  iat?: number
  exp?: number
}

let cachedSecret: string | null = null

export function getJwtSecret(): string {
  if (cachedSecret) {
    return cachedSecret
  }

  const secret = process.env.JWT_SECRET?.trim()

  if (!secret) {
    const message = 'JWT_SECRET environment variable must be provided'
    console.error(`[AUTH] ${message}`)
    throw new Error(message)
  }

  cachedSecret = secret
  return cachedSecret
}

export function signJwt(payload: JwtPayload) {
  return jwt.sign(payload, getJwtSecret(), { expiresIn: '7d' })
}

export function verifyJwt(token: string): JwtPayload | null {
  try {
    return jwt.verify(token, getJwtSecret()) as JwtPayload
  } catch {
    return null
  }
}
