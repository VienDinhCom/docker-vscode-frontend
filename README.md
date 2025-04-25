# Docker Flow for Front End Development

## Development

Build the development image and run it with the host's `UID` and `GID`.

```
UID=$(id -u) GID=$(id -g) docker compose --profile development up --build
```

Use an SSH CLI or an editor with SSH support, such as VSCode or Zed, to connect to and work inside the development container.

```
ssh -p 2230 frontend@localhost
```

After connecting to the container with SSH, go to the working directory.

```
cd project
```

Install project dependencies.

```
npm install
```

Run the app in the development mode.

```
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

## Production

Build the production image and run it with the host's `UID` and `GID`.

```
docker compose --profile production up --build
```

Open [http://localhost:3000](http://localhost:3000) to view it in your browser.
