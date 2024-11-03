FROM ruby:3.2.0

ENV APP /src
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt update -qq \
  && apt install -y build-essential mariadb-client nodejs \
  && npm install --global yarn
RUN yarn add @fortawesome/fontawesome-free @fortawesome/fontawesome-svg-core @fortawesome/free-brands-svg-icons @fortawesome/free-regular-svg-icons @fortawesome/free-solid-svg-icons
WORKDIR $APP
COPY ./docker/web/Gemfile $APP/Gemfile
COPY ./docker/web/Gemfile.lock $APP/Gemfile.lock
RUN bundle install
