import { Injectable } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import * as jwt from 'jsonwebtoken';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaClient) {}

  async validateUser(email: string, displayName?: string) {
    const user = await this.prisma.user.upsert({
      where: { email },
      update: {},
      create: { email, displayName },
    });
    return user;
  }

  generateToken(userId: string) {
    const secret = process.env.JWT_SECRET || 'secret';
    return jwt.sign({ sub: userId }, secret, { expiresIn: '7d' });
  }
}
