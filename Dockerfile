FROM node:22-alpine AS base

ARG UID=1000
ARG GID=1000
ARG USR=frontend

# Nonroot User
RUN apk add --no-cache shadow
RUN getent passwd ${UID} && userdel $(getent passwd ${UID} | cut -d: -f1)
RUN getent group ${GID} || groupadd --gid ${GID} ${USR}
RUN useradd --uid ${UID} --gid ${GID} -m ${USR}

WORKDIR /home/${USR}/project


# TARGET: DEVELOPMENT
##################################################################
FROM base AS development

ENV NODE_ENV=development
ENV API_URL=http://backend:8080

# Fish Shell
RUN apk add fish
RUN chsh -s $(which fish) ${USR}

# VSCode CLI 
RUN apk add --no-cache musl libgcc libstdc++
RUN wget -q https://vscode.download.prss.microsoft.com/dbazure/download/stable/17baf841131aa23349f217ca7c570c76ee87b957/vscode_cli_alpine_x64_cli.tar.gz \
    && tar -xzf vscode_cli_alpine_x64_cli.tar.gz \
    && mv code /usr/bin/ \
    && rm vscode_cli_alpine_x64_cli.tar.gz

# Dev Tools
RUN apk add --no-cache coreutils findutils openssh-client git

EXPOSE 3000 53000 

USER ${USR}

CMD ["sh", "-c", "code serve-web --host 0.0.0.0 --port 53000 --accept-server-license-terms --without-connection-token --server-data-dir ${HOME}/project/.vscode/server"]


# TARGET: BUILD 
##################################################################
FROM base AS build

ENV NODE_ENV=development
ENV API_URL=http://backend:8080

COPY package*.json ./
RUN npm install

COPY . .

RUN chown -R ${UID}:${UID} /home/${USR}/project

USER ${USR}

RUN npm run build


# TARGET: PRODUCTION 
##################################################################
FROM base AS production

ENV NODE_ENV=production

COPY --from=build /home/${USR}/project/dist .

RUN chown -R ${UID}:${UID} /home/${USR}/project

RUN npm install -g serve

EXPOSE 3000

USER ${USR}

CMD ["serve", "-l", "3000", "."]