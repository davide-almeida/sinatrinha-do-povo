FROM ruby:3.3

WORKDIR /app

ENV RUBY_YJIT_ENABLE=1

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install
