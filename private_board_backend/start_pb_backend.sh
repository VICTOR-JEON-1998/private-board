#!/bin/bash

echo "🔁 Starting PostgreSQL Docker container..."
sudo docker start pb-postgres

echo "✅ PostgreSQL started."

echo "🚀 Starting NestJS backend..."
cd ~/project/private-board/private_board_backend

npm run dev

