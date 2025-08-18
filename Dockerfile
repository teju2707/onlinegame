# Use a supported Node.js LTS base image (update for prod if needed)
FROM node:18-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy only package.json + package-lock.json first, for better cache
COPY package*.json ./

# Install dependencies
RUN npm ci --production

# Copy rest of the application code
COPY . .

# (Optional) Build step for React/Next:
RUN [ -f package.json ] && npm run build || echo "No build step"

# Expose app port (change as needed)
EXPOSE 3000

# Start app
CMD ["npm", "start"]
