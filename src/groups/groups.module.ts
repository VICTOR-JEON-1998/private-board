import { Module } from '@nestjs/common';
import { GroupsService } from './groups.service';
import { GroupsController } from './groups.controller';
import { JwtAuthGuard } from '../auth/jwt.guard';
import { InvitesModule } from '../invites/invites.module';

@Module({
  imports: [InvitesModule],
  providers: [GroupsService, JwtAuthGuard],
  controllers: [GroupsController],
})
export class GroupsModule {}
