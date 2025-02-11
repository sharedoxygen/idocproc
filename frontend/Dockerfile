FROM node:18-alpine

WORKDIR /app

ENV NODE_ENV=development

# Copy package files first for better caching
COPY package*.json ./
COPY vite.config.js ./
COPY tailwind.config.js ./

# Install dependencies including devDependencies
RUN npm install --legacy-peer-deps

# Copy the rest of the application
COPY . .

EXPOSE 3000

# Build for production if in prod environment, otherwise run dev server
CMD if [ "$NODE_ENV" = "production" ]; then \
    npm run build && \
    npm run preview; \
    else \
    npm run dev -- --host; \
    fi 