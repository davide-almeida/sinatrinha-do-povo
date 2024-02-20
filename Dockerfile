FROM ruby:3.3 AS base
ENV RUBY_YJIT_ENABLE=1
WORKDIR /app

FROM base AS prod
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
COPY . .
EXPOSE 8080
CMD ["ruby", "server.rb", "-o", "0.0.0.0", "-p", "8080"]
