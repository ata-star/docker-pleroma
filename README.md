# Pleroma

[Pleroma](https://pleroma.social/) is a federated social networking platform, compatible with GNU social and other OStatus implementations. It is free software licensed under the AGPLv3.
It actually consists of two components: a backend, named simply Pleroma, and a user-facing frontend, named Pleroma-FE.
Its main advantages are its lightness and speed.

## Features

- Based on the elixir:alpine image
- It works

Sadly, this is not a reusable (e.g. I can't upload it to the Docker Hub), because for now Pleroma needs to compile the configuration. 
Thus you will need to build the image yourself, but I explain how to do it below.

## Build-time variables

- **`PLEROMA_VER`** : Pleroma version (latest commit of the [`develop` branch](https://git.pleroma.social/pleroma/pleroma) by default)
- **`GID`**: group id (default: `911`)
- **`UID`**: user id (default: `911`)

## Usage

### Installation

Create a folder for your Pleroma instance. Inside, you should clone this repo.

In the `docker-compose.yml`. You should change the `POSTGRES_PASSWORD` variable.


Configure Pleroma. Edit `config/secret.exs`:
You need to change at least:

- `host`
- `secret_key_base`
- `email`

Make sure your PostgreSQL parameters are ok.


Run:
```sh
cd docker-pleroma #if not already in that folder
sh setup.sh
```


Get your web push keys and copy them to `secret.exs`:

```
docker-compose run --rm web mix web_push.gen.keypair
```

You will need to build the image again, to pick up your updated `secret.exs` file:

```
docker-compose build
```

You can now launch your instance:

```sh
docker-compose up -d
```

Check if everything went well with:

```sh
docker logs -f pleroma_web
```

You can now setup a Nginx reverse proxy in a container or on your host by using the [example Nginx config](https://git.pleroma.social/pleroma/pleroma/blob/develop/installation/pleroma.nginx).

### Update

By default, the Dockerfile will be built from the latest commit of the `develop` branch as Pleroma does not have releases for now.

Thus to update, just rebuild your image and recreate your containers:

```sh
docker-compose pull # update the PostgreSQL if needed
docker-compose build .
# or
docker build -t pleroma .
docker-compose run --rm web mix ecto.migrate # migrate the database if needed
docker-compose up -d # recreate the containers if needed
```

If you want to run a specific commit, you can use the `PLEROMA_VER` variable:

```sh
docker build -t pleroma . --build-arg PLEROMA_VER=a9203ab3
```

`a9203ab3` being the hash of the commit. (They're [here](https://git.pleroma.social/pleroma/pleroma/commits/develop))

## Other Docker images

Here are other Pleroma Docker images that helped me build mine:

- [potproject/docker-pleroma](https://github.com/potproject/docker-pleroma)
- [rysiek/docker-pleroma](https://git.pleroma.social/rysiek/docker-pleroma)
- [RX14/iscute.moe](https://github.com/RX14/kurisu.rx14.co.uk/blob/master/services/iscute.moe/pleroma/Dockerfile)
