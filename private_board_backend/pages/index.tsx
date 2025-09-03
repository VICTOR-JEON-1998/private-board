import type { NextApiRequest, NextApiResponse } from "next";
import { prisma } from "@/lib/prisma";
import { getUserIdFromReq } from "@/lib/auth";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "GET") return res.status(405).end();

  const userId = getUserIdFromReq(req);
  if (!userId) return res.status(401).json({ error: "Unauthorized" });

  const groups = await prisma.group.findMany({
    where: {
      OR: [
        { createdBy: { is: { id: userId } } }, // 스키마 최소패치 전에도 동작
        { User: { some: { id: userId } } },    // 현재 네 스키마의 relation 이름
      ],
    },
    orderBy: { createdAt: "desc" },
    select: { id: true, groupId: true, name: true, createdAt: true },
  });

  return res.status(200).json(groups);
}
