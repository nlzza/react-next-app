# Use the official Node.js 16 image as the base image
FROM node:18 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
# COPY package*.json ./
# Copy the application code to the working directory
COPY . .

# Install the application dependencies
RUN npm install


# Build the Next.js application
RUN npm run build

# Use a minimal Node.js image to run the app
FROM node:18-alpine AS runner

# Set the working directory inside the container
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/.next /app/.next
COPY --from=builder /app/public /app/public
COPY --from=builder /app/package*.json /app/

# Install only production dependencies
RUN npm install

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the Next.js application
CMD ["npm", "start"]
