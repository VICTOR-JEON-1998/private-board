import { Module } from '@nestjs/common';
import { InvitesService } from './invites.service';
import { InvitesController } from './invites.controller';
import { JwtAuthGuard } from '../auth/jwt.guard';

@Module({
  providers: [InvitesService, JwtAuthGuard],
  controllers: [InvitesController],
  exports: [InvitesService],
})
export class InvitesModule {}
