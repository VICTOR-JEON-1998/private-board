import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { GroupsModule } from './groups/groups.module';
import { UsersModule } from './users/users.module';
import { MembersModule } from './members/members.module';
import { PostsModule } from './posts/posts.module';
import { CommentsModule } from './comments/comments.module';
import { ReactionsModule } from './reactions/reactions.module';
import { InvitesModule } from './invites/invites.module';
import { AppController } from './app.controller';

@Module({
  imports: [
    AuthModule,
    UsersModule,
    GroupsModule,
    MembersModule,
    PostsModule,
    CommentsModule,
    ReactionsModule,
    InvitesModule,
  ],
  controllers: [AppController],
})
export class AppModule {}
