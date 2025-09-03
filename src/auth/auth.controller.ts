import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './login.dto';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  async login(@Body() dto: LoginDto) {
    const user = await this.authService.validateUser(dto.email, dto.displayName);
    const token = this.authService.generateToken(user.id);
    return { token, user: { id: user.id, email: user.email, displayName: user.displayName } };
  }
}
