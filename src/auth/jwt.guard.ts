import { CanActivate, ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private prisma: PrismaClient) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const auth = request.headers['authorization'];
    if (!auth) throw new UnauthorizedException('Missing token');
    const [scheme, token] = auth.split(' ');
    if (scheme !== 'Bearer' || !token) throw new UnauthorizedException('Invalid token');
    try {
      const payload = jwt.verify(token, process.env.JWT_SECRET || 'secret') as { sub: string };
      const user = await this.prisma.user.findUnique({ where: { id: payload.sub } });
      if (!user) throw new UnauthorizedException('User not found');
      request.user = { id: user.id };
      return true;
    } catch (e) {
      throw new UnauthorizedException('Invalid token');
    }
  }
}
