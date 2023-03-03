FROM ruby:3.1.2-alpine3.14

RUN apk add --no-cache \
  build-base \
  postgresql-dev \
  postgresql-client \
  nodejs \
  yarn \
  tzdata

RUN gem install bundler:2.2.28

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 20 --retry 5

COPY . .

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]