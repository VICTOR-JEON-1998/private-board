import { Body, Controller, Get, Param, Post, UseGuards, Req } from '@nestjs/common';
import { GroupsService } from './groups.service';
import { CreateGroupDto } from './dto/create-group.dto';
import { JoinGroupDto } from './dto/join-group.dto';
import { JwtAuthGuard } from '../auth/jwt.guard';

@Controller('groups')
export class GroupsController {
  constructor(private groupsService: GroupsService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Req() req, @Body() dto: CreateGroupDto) {
    return this.groupsService.createGroup(req.user.id, dto.groupName, dto.groupId, dto.password);
  }

  @UseGuards(JwtAuthGuard)
  @Post('join')
  join(@Req() req, @Body() dto: JoinGroupDto) {
    return this.groupsService.joinGroup(req.user.id, dto.groupId, dto.password);
  }

  @UseGuards(JwtAuthGuard)
  @Get(':groupId')
  get(@Param('groupId') groupId: string) {
    return this.groupsService.getGroup(groupId);
  }
}
