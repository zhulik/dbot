FROM ruby:2.6.3

ENV WORKDIR /app

WORKDIR ${WORKDIR}

RUN gem install bundler
RUN bundle config set --local deployment 'true'
RUN bundle config set --local without 'development test'

ADD Gemfile .
ADD Gemfile.lock .

RUN bundle install -j$(nproc)

ADD . .
