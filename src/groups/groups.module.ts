import { Module } from '@nestjs/common';
import { GroupsService } from './groups.service';
import { GroupsController } from './groups.controller';
import { PrismaClient } from '@prisma/client';
import { JwtAuthGuard } from '../auth/jwt.guard';

@Module({
  providers: [GroupsService, PrismaClient, JwtAuthGuard],
  controllers: [GroupsController],
})
export class GroupsModule {}
