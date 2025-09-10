import { Module } from '@nestjs/common';
import { InvitesService } from './invites.service';
import { InvitesController } from './invites.controller';
import { PrismaClient } from '@prisma/client';
import { JwtAuthGuard } from '../auth/jwt.guard';

@Module({
  providers: [InvitesService, PrismaClient, JwtAuthGuard],
  controllers: [InvitesController],
  exports: [InvitesService],
})
export class InvitesModule {}
