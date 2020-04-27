FROM ubuntu:20.04 AS build

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget gnupg2

RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb

RUN dpkg -i erlang-solutions_2.0_all.deb
RUN apt-get update && apt-get install -y esl-erlang elixir=1.10.2-1

WORKDIR /app

RUN mix local.hex --force &&  mix local.rebar --froce

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

COPY priv priv
RUN mix phx.digest

COPY lib lib
COPY rel rel
RUN mix do compile, release

FROM ubuntu:20.04 AS app

WORKDIR /app

RUN chown nobody:nogroup /app

USER nobody:nogroup

COPY --from=build --chown=nobody:nogroup /app/_build/prod/rel/hello_phoenix ./

ENV HOME=/app

CMD ["bin/hello_phoenix", "start"]
