import { Injectable, BadRequestException, ForbiddenException, NotFoundException } from '@nestjs/common';
import { PrismaClient, Role } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

@Injectable()
export class GroupsService {
  constructor(private prisma: PrismaClient) {}

  async createGroup(userId: string, groupName: string, groupId: string, password?: string) {
    const hash = password ? await bcrypt.hash(password, 10) : undefined;
    try {
      return await this.prisma.group.create({
        data: {
          groupName,
          groupId,
          passwordHash: hash,
          createdById: userId,
          members: {
            create: {
              userId,
              role: Role.ADMIN,
            },
          },
        },
      });
    } catch (e) {
      throw new BadRequestException('Group creation failed');
    }
  }

  async joinGroup(userId: string, groupId: string, password?: string) {
    const group = await this.prisma.group.findUnique({ where: { groupId } });
    if (!group) throw new NotFoundException('Group not found');
    if (group.passwordHash) {
      const valid = await bcrypt.compare(password || '', group.passwordHash);
      if (!valid) throw new ForbiddenException('Invalid password');
    }
    return this.prisma.groupMember.upsert({
      where: { groupId_userId: { groupId: group.id, userId } },
      update: { status: 'ACTIVE' },
      create: { groupId: group.id, userId, role: Role.MEMBER },
    });
  }

  async getGroup(groupId: string) {
    const group = await this.prisma.group.findUnique({
      where: { groupId },
      include: { members: true, createdBy: true },
    });
    if (!group) throw new NotFoundException('Group not found');
    return {
      id: group.id,
      groupId: group.groupId,
      groupName: group.groupName,
      createdById: group.createdById,
      memberCount: group.members.length,
    };
  }

  async isGroupIdAvailable(groupId: string) {
    if (!groupId) throw new BadRequestException('groupId is required');
    const existing = await this.prisma.group.findUnique({
      where: { groupId },
      select: { id: true },
    });
    return !existing;
  }
}
