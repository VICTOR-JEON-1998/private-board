import type { NextApiRequest, NextApiResponse } from "next";
import { prisma } from "@/lib/prisma";
import { getUserIdFromReq } from "@/lib/auth";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "GET") return res.status(405).end();

  const userId = getUserIdFromReq(req);
  if (!userId) return res.status(401).json({ error: "Unauthorized" });

  // pages/api/groups/index.ts
  const groups = await prisma.group.findMany({
    where: {
      OR: [
        { createdById: userId },
        { User: { some: { id: userId } } },
      ],
    },
    orderBy: { createdAt: "desc" },
    select: {
      id: true,
      groupId: true,   // ← 꼭 포함
      name: true,
      createdAt: true,
    },
  });

  return res.status(200).json(groups);
}
