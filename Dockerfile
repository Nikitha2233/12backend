FROM --platform=linux/amd64 node:20-slim

ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/appuser" \
    --shell "/sbin/nologin" \
    --uid "${UID}" \
    appuser

WORKDIR /app

ENV LIVEKIT_URL=wss://idea-mwqr3qhm.livekit.cloud
ENV LIVEKIT_API_KEY=APIQiGNst42SC42
ENV LIVEKIT_API_SECRET=CRo9ZyrepVQtEPUAn18jzU04e2zSOwhk78SoWh0s6fyB
ENV OPENAI_API_KEY=GA6BIWIBHVC25TG2KQUJNZ2FZQ4M44QPVYGUGDXM7WZ7K7F4FW3DG2ZQ
ENV MONGODB_URL=mongodb://localhost:27017

RUN apt-get update && apt-get install -y ca-certificates openssl wget python3 make g++ && \
    update-ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY package*.json ./
COPY tsconfig.json ./

RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build

RUN npm prune --omit=dev --legacy-peer-deps
COPY .env .env

USER appuser

EXPOSE 3000

CMD ["node", "dist/agent.js", "start"]

