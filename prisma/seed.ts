import { PrismaClient, Role } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const user = await prisma.user.upsert({
    where: { email: 'victor@example.com' },
    update: {},
    create: {
      email: 'victor@example.com',
      displayName: 'Victor',
    },
  });

  await prisma.group.upsert({
    where: { groupId: 'family-2025' },
    update: {},
    create: {
      groupName: 'Family 2025',
      groupId: 'family-2025',
      createdById: user.id,
      members: {
        create: {
          userId: user.id,
          role: Role.ADMIN,
        },
      },
    },
  });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
