# Docker Flow for Front End Development

## Development

Build the development image and run it with the host's `UID` and `GID`.

```
UID=$(id -u) GID=$(id -g) docker compose --profile development up --build
```

Open [http://localhost:53000](http://localhost:53000) to develop inside the container with Visual Studio Code directly in your browser.

Open the project in the terminal using the command:

```
code frontend
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
