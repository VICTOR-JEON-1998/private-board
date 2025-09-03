import { IsOptional, IsString, Matches } from 'class-validator';

export class JoinGroupDto {
  @Matches(/^[a-z0-9-]{3,30}$/)
  groupId: string;

  @IsOptional()
  @IsString()
  password?: string;
}
