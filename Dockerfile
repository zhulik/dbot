FROM ruby:2.6.3

RUN apt-get update -y &&\
  apt-get install -y -q ffmpeg &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists

ENV WORKDIR /app

WORKDIR ${WORKDIR}

RUN gem install bundler
RUN bundle config set --local deployment 'true'
RUN bundle config set --local without 'development test'

ADD Gemfile .
ADD Gemfile.lock .

RUN bundle install -j$(nproc)

ADD . .
