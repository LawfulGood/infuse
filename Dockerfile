FROM library/elixir:1.4
MAINTAINER Luke Strickland (@clone1018)

ENV DEBIAN_FRONTEND noninteractive

# Install other stable dependencies that don't change often

# Compile app
RUN mkdir /app
COPY ./ /app
WORKDIR /app

# Install Elixir Deps
ADD mix.* ./
RUN mix local.rebar
RUN mix local.hex --force
RUN mix deps.get

# Install app
ADD . .
RUN mix compile

# Exposes this port from the docker container to the host machine
EXPOSE 8101

# The command to run when this image starts up
CMD mix run --no-halt