import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { randomBytes } from 'crypto';

@Injectable()
export class InvitesService {
  constructor(private prisma: PrismaClient) {}

  async createCode(userId: string, groupId: string, expiresAt?: Date, maxUses?: number) {
    const code = randomBytes(3).toString('hex');
    return this.prisma.inviteCode.create({
      data: {
        groupId,
        code,
        expiresAt,
        maxUses,
        createdById: userId,
      },
    });
  }

  async getCode(code: string) {
    const invite = await this.prisma.inviteCode.findUnique({ where: { code } });
    if (!invite) throw new NotFoundException('Invite code not found');
    return invite;
  }

  async verifyCode(code: string) {
    const invite = await this.prisma.inviteCode.findUnique({ where: { code } });
    if (!invite) throw new NotFoundException('Invalid invite code');
    if (invite.expiresAt && invite.expiresAt < new Date()) {
      throw new BadRequestException('Invite code expired');
    }
    if (invite.maxUses && invite.useCount >= invite.maxUses) {
      throw new BadRequestException('Invite code has been used up');
    }
    return invite;
  }
}
