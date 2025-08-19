FROM node:20-alpine

WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci --omit=dev --no-audit

# Copy source code AFTER installing dependencies
COPY . .

# Expose port if needed
EXPOSE 3000

# Start command
CMD ["npm", "start"]
