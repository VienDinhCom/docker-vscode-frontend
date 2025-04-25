FROM node:22-alpine AS base

ARG USR
ARG UID=1000
ARG GID=1000

RUN apk add --no-cache shadow

# Nonroot User
RUN userdel node
RUN getent group ${GID} || groupadd --gid ${GID} ${USR}
RUN useradd --uid ${UID} --gid ${GID} -m ${USR}


WORKDIR /home/${USR}/project


# TARGET: DEVELOPMENT
##################################################################
FROM base AS development

# Fish Shell
RUN apk add fish
RUN chsh -s $(which fish) ${USR}

# SSH Server 
RUN apk add openssh
RUN ssh-keygen -A
RUN passwd -d ${USR}
RUN echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config

# # Dev Tools
# RUN apk add git

# ENV API_URL=
# ENV NODE_ENV=development

# EXPOSE 3000 22

# USER root

# CMD ["/usr/sbin/sshd", "-D"]


# # TARGET: PRODUCTION 
# ##################################################################
# FROM base AS build

# COPY package*.json ./

# RUN npm install

# COPY . .

# RUN npm run build

# # Next

# FROM base AS production

# ENV NODE_ENV=production

# COPY --from=build /home/${USR}/project/dist/client .

# RUN npm install -g serve

# EXPOSE 3000

# RUN chown -R ${UID}:${UID} /home/${USR}/project

# USER ${USR}

# CMD ["serve", "-l", "3000", "."]