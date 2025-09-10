import { Module } from '@nestjs/common';
import { PostsService } from './posts.service';
import { PostsController } from './posts.controller';
import { PrismaClient } from '@prisma/client';
import { JwtAuthGuard } from '../auth/jwt.guard';

@Module({
  providers: [PostsService, PrismaClient, JwtAuthGuard],
  controllers: [PostsController],
})
export class PostsModule {}
