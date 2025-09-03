import { IsOptional, IsString, Matches, MaxLength, MinLength } from 'class-validator';

export class CreateGroupDto {
  @Matches(/^[a-z0-9-]{3,30}$/)
  groupId: string;

  @IsString()
  @MinLength(1)
  @MaxLength(50)
  groupName: string;

  @IsOptional()
  @IsString()
  password?: string;
}
