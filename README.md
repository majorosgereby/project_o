# project_o

## The server

The server is an express server running on NodeJS. To run the server file `NodeJS` and `npm` is required.

### Installation

First, the requried packages (found in `package.json`) need to be installed:

```bash
npm i
```

### Running the server

The server by default runs on port `3000`, but this can be overwritten by supporting a `.env` file in the same directory. A `.env_example` can be found in the directory.

```bash
PORT=8128
```

To run the server, type the following command:

```bash
npm start
```

First it will try for `.env`, if it isn't found it runs without it.

## The Docker image of the server

Using Docker the image of the server can be built locally: (In the example `project_o` tag is given)

```bash
docker build -t project_o .
```

When running the container we have the option to either use the default port (3000) or support the same `.env` file as before. The examples will run the container in detached mode.

Without `.env`:

```bash
docker run -d -p LOCAL_PORT:3000 project_o
```

With `.env`:

```bash
docker run -d --env-file .env -p LOCAL_PORT:ENV_PORT project_o
```