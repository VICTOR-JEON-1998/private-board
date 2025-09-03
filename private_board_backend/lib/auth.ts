// lib/auth.ts
import jwt from "jsonwebtoken";
import type { NextApiRequest } from "next";

type JwtPayload = {
  userId?: string;     // 앱에서 쓰던 형태
  sub?: string;        // 이전(또는 다른 서비스)에서 쓰던 형태
  email?: string;
  iat?: number;
  exp?: number;
};

export function signJwt(payload: JwtPayload) {
  const secret = process.env.JWT_SECRET!;
  return jwt.sign(payload, secret, { expiresIn: "7d" });
}

export function verifyJwt(token: string): JwtPayload | null {
  try {
    const secret = process.env.JWT_SECRET!;
    return jwt.verify(token, secret) as JwtPayload;
  } catch {
    return null;
  }
}

export function getTokenFromReq(req: NextApiRequest): string | null {
  const auth = req.headers.authorization ?? "";
  return auth.startsWith("Bearer ") ? auth.slice(7) : null;
}

export function getUserIdFromReq(req: NextApiRequest): string | null {
  const token = getTokenFromReq(req);
  if (!token) return null;

  const payload = verifyJwt(token);
  // 🔑 핵심: sub → userId 순으로 모두 대응
  const uid = payload?.userId ?? payload?.sub ?? null;

  // ▼ 임시 디버깅 로그 (원인 확정 후 지워도 됨)
  if (!uid) {
    console.error("[AUTH] token present but no uid/sub in payload:", payload);
  }
  return uid ?? null;
}
