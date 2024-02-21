# Docker setup

```bash
docker-compose build --no-cache

docker-compose run --rm app mix deps.get
docker-compose run --rm app mix ecto.setup
```

# Create new project steps

## Outside of code

Create `docker-compose.yml`
Create `Dockerfile`

## Code steps

```bash
docker-compose run --rm app bash
# Generates `mix.exs`
mix new ${path}

# Installs the phx.new task
mix archive.install hex phx_new

# Generates new phoenix app
mix phx.new ${path}
```
