FROM ruby:2.7.1 AS ruby_base
FROM node:13.11.0

COPY --from=ruby_base . .

ENV APP_HOME /payment-system

RUN apt-get update -qq \
  && apt-get install -y \
    build-essential \
    libc6-dev \
    libpq-dev \
    cron \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
COPY package.json $APP_HOME/
COPY yarn.lock $APP_HOME/

RUN bundle install
RUN yarn install --check-files

ADD . $APP_HOME

RUN crontab -l | { cat; echo ""; } | crontab -

RUN bundle exec whenever --update-crontab
