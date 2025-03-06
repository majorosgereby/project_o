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