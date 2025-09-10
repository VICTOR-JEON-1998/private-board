import { Body, Controller, Get, Param, Post, Req, UseGuards } from '@nestjs/common';
import { InvitesService } from './invites.service';
import { JwtAuthGuard } from '../auth/jwt.guard';

@Controller('invites')
export class InvitesController {
  constructor(private invitesService: InvitesService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Req() req, @Body() body: { groupId: string; expiresAt?: string; maxUses?: number }) {
    const expiresAt = body.expiresAt ? new Date(body.expiresAt) : undefined;
    return this.invitesService.createCode(req.user.id, body.groupId, expiresAt, body.maxUses);
  }

  @UseGuards(JwtAuthGuard)
  @Get(':code')
  findOne(@Param('code') code: string) {
    return this.invitesService.getCode(code);
  }

  @Get(':code/verify')
  verify(@Param('code') code: string) {
    return this.invitesService.verifyCode(code);
  }
}
