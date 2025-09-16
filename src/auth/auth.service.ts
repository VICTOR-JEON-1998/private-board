import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { signJwt } from './jwt.util';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService) {}

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
