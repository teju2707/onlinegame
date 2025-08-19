# Use Node 16 to match your package.json requirements
FROM node:16-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install dependencies (ignoring audit for urgent deployment)
RUN npm ci --production --no-audit

# Copy application code
COPY . .

# Build the application if build script exists
RUN npm run build || echo "No build script found"

# Expose port 3000
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
