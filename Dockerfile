FROM alpine:3.21 AS base

ARG USR=user
ARG UID=1000
ARG GID=1000
ARG PRJ=frontend

ENV PROJECT=${PRJ}
ENV API_URL=https://example.com/api

# Nonroot User
RUN apk add --no-cache shadow
RUN getent passwd ${UID} && userdel $(getent passwd ${UID} | cut -d: -f1) || true
RUN getent group ${GID} || groupadd --gid ${GID} ${USR}
RUN useradd --uid ${UID} --gid ${GID} -m ${USR}

# Production Dependencies
RUN apk add --no-cache nodejs npm
RUN npm install -g serve

WORKDIR /home/${USR}/${PRJ}


# TARGET: DEVELOPMENT
##################################################################
FROM base AS development

ENV NODE_ENV=development

# Bash Shell
RUN apk add --no-cache bash bash-completion
RUN echo '. /etc/bash/bash_completion.sh' >> /etc/bash/bashrc
RUN echo "PS1='\[\e[1;33m\]${PRJ}\[\e[0m\] \[\e[0;32m\]\w\[\e[0m\]> '" >> /etc/bash/bashrc
RUN chsh -s $(which bash) ${USR}

# VSCode CLI 
RUN apk add --no-cache musl libgcc libstdc++ gcompat
RUN wget -q https://vscode.download.prss.microsoft.com/dbazure/download/stable/17baf841131aa23349f217ca7c570c76ee87b957/vscode_cli_alpine_x64_cli.tar.gz \
    && tar -xzf vscode_cli_alpine_x64_cli.tar.gz \
    && mv code /usr/bin/ \
    && rm vscode_cli_alpine_x64_cli.tar.gz

# Development Dependencies
RUN apk add --no-cache coreutils findutils openssh-client curl git

EXPOSE 3000 53000 

USER ${USR}

CMD ["sh", "-c", "code serve-web --host 0.0.0.0 --port 53000 --accept-server-license-terms --without-connection-token --server-data-dir ${HOME}/${PROJECT}/.vscode/server"]


# TARGET: BUILD 
##################################################################
FROM base AS build

ENV NODE_ENV=development

COPY package*.json ./
RUN npm install

COPY . .

RUN chown -R ${UID}:${UID} /home/${USR}/${PRJ}

USER ${USR}

RUN npm run build


# TARGET: PRODUCTION 
##################################################################
FROM base AS production

ENV NODE_ENV=production

COPY --from=build /home/${USR}/${PRJ}/dist .

RUN chown -R ${UID}:${UID} /home/${USR}/${PRJ}

EXPOSE 3000

USER ${USR}

CMD ["npm", "run", "start"]