# docker-devflow-frontend

# Development

Build the development image and run it with the host's `UID` and `GID`.

```
UID=$(id -u) GID=$(id -g) docker compose up --build
```

Use an SSH CLI or an editor with SSH support, such as VS Code or Zed, to connect to and work inside the development container."

```
ssh -p 2233 frontend@localhost
```

Go to the working directory.

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
