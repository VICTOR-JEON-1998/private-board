#!/bin/bash
set -e

PORT=${PORT:-3000}
PID=$(lsof -Pi :$PORT -sTCP:LISTEN -t || true)
if [ -n "$PID" ]; then
  kill $PID
fi

npx prisma migrate deploy || true
npm run start
