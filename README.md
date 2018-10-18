# Docker node webpack
A template example of a node alpine container using babel, webpack, vue, prettier with eslint and stylelint integration and jest testing.

# Usage
I added a bunch of docker scripts in docker/docker.sh eg:
- **Start app**: `yarn d start`, or `yarn d start prod` for production
- **Get list of scripts**: `yarn d help`
- **Check container log**: `yarn d logs`
- **Clean up everything**: `yarn d rmall`

There is an `.env` file you might want to check out. Default port is 3000 so the app should be available on `http://localhost:3000/` after installing.

`yarn install` is run inside the app container on startup, but should be able to run outside as well.

I put some empty placeholder files in the app eg: `package.json`, `startup.sh` to ensure correct permissions are set when they are mounted in `docker-compose.yml`
