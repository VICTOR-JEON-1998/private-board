import type { NextApiRequest, NextApiResponse } from "next";
import bcrypt from "bcryptjs";
import crypto from "crypto";
import { prisma } from "@/lib/prisma";
import { getUserIdFromReq } from "@/lib/auth";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "POST") return res.status(405).end();

  const userId = getUserIdFromReq(req);
  if (!userId) return res.status(401).json({ error: "Unauthorized" });

  const { groupId, name, password } = req.body ?? {};
  if (!groupId || !name || !password) {
    return res.status(400).json({ error: "Missing fields" });
  }

  const exists = await prisma.group.findUnique({ where: { groupId } });
  if (exists) return res.status(409).json({ error: "GROUP_ID_TAKEN" });

  const passwordHash = await bcrypt.hash(password, 10);

  const group = await prisma.group.create({
    data: {
      groupId,
      name,
      passwordHash,
      invitationCode: crypto.randomUUID().slice(0, 8),
      hasAdmin: true,
      // 스키마 최소패치 전/후 모두 호환되게:
      createdBy: { connect: { id: userId } },   // (최소패치 전에도 OK)
      // createdById: userId,                    // (최소패치 적용했다면 이 라인으로 대체해도 OK)
    },
    select: { id: true, groupId: true, name: true, createdAt: true },
  });

  return res.status(201).json(group);
}
