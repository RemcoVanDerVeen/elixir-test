# BUILD
FROM elixir:1.16 as build

ARG MIX_ENV="dev"
ENV MIX_ENV="${MIX_ENV}" \
    MIX_HOME=/opt/mix \
    HEX_HOME=/opt/hex \
    APP_DIR=/opt/app \
    DATABASE_URL=${DATABASE_URL}

RUN apt-get --allow-releaseinfo-change update &&\
    apt-get install --no-install-recommends -qq \
    git \
    make \
    curl \
    && mkdir -p ${MIX_HOME} \
    && mkdir -p ${HEX_HOME} \
    && mix do local.hex --force, local.rebar --force

WORKDIR ${APP_DIR}

# Always install latest versions of Hex and Rebar
ONBUILD RUN mix do local.hex --force, local.rebar --force

# Cache mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV \
    && mix deps.compile

# Copy compile configuration files
COPY config/config.exs config/$MIX_ENV.exs config/

FROM build as dev

RUN apt-get --allow-releaseinfo-change update &&\
    apt-get install --no-install-recommends -qq \
      inotify-tools \
      bash

RUN mix do compile, phx.digest

CMD ["mix", "phx.server"]
