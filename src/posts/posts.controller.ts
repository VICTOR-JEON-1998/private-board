import { Body, Controller, Delete, Get, Param, Patch, Post as HttpPost, Query, Req, UseGuards } from '@nestjs/common';
import { PostsService } from './posts.service';
import { JwtAuthGuard } from '../auth/jwt.guard';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';

@UseGuards(JwtAuthGuard)
@Controller('posts')
export class PostsController {
  constructor(private postsService: PostsService) {}

  @HttpPost()
  create(@Req() req, @Body() dto: CreatePostDto) {
    return this.postsService.createPost(req.user.id, dto.groupId, dto.title, dto.content);
  }

  @Get()
  findAll(@Query('groupId') groupId?: string) {
    return this.postsService.findAll(groupId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.postsService.findOne(id);
  }

  @Patch(':id')
  update(@Req() req, @Param('id') id: string, @Body() dto: UpdatePostDto) {
    return this.postsService.updatePost(req.user.id, id, dto.title, dto.content);
  }

  @Delete(':id')
  remove(@Req() req, @Param('id') id: string) {
    return this.postsService.deletePost(req.user.id, id);
  }
}
