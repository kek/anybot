FROM elixir:1.9.4
RUN apt-get update && apt-get upgrade
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs
