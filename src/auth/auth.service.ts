import { Injectable } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { signJwt } from './jwt.util';

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
    return signJwt({ sub: userId });
  }
}
