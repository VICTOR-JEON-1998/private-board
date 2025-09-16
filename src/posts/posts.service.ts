import { Injectable, ForbiddenException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PostsService {
  constructor(private prisma: PrismaService) {}

  async createPost(userId: string, groupId: string, title: string, content: string) {
    const membership = await this.prisma.groupMember.findFirst({
      where: { groupId, userId },
    });
    if (!membership) {
      throw new ForbiddenException('User is not a member of this group');
    }
    return this.prisma.post.create({
      data: { title, content, groupId, authorId: userId },
    });
  }

  async findAll(groupId?: string) {
    return this.prisma.post.findMany({
      where: groupId ? { groupId } : undefined,
      orderBy: { createdAt: 'desc' },
      include: {
        author: {
          select: { id: true, email: true },
        },
      },
    });
  }

  async findOne(id: string) {
    const post = await this.prisma.post.findUnique({
      where: { id },
      include: {
        author: {
          select: { id: true, email: true },
        },
      },
    });
    if (!post) throw new NotFoundException('Post not found');
    return post;
  }

  async updatePost(userId: string, id: string, title?: string, content?: string) {
    const post = await this.prisma.post.findUnique({ where: { id } });
    if (!post) throw new NotFoundException('Post not found');
    if (post.authorId !== userId) {
      throw new ForbiddenException('Not your post');
    }
    return this.prisma.post.update({
      where: { id },
      data: { title, content },
    });
  }

  async deletePost(userId: string, id: string) {
    const post = await this.prisma.post.findUnique({ where: { id } });
    if (!post) throw new NotFoundException('Post not found');
    if (post.authorId !== userId) {
      throw new ForbiddenException('Not your post');
    }
    return this.prisma.post.delete({ where: { id } });
  }
}
