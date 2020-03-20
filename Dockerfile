FROM ruby:2.6.5-slim
MAINTAINER dionne.phil@gmail.com

# Defaults
ARG APP_ENV
ARG PORT

ENV APP_ENV ${APP_ENV}
ENV PORT ${PORT}

# Run updates, install basics and cleanup
# - build-essential: Compile specific gems
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up app directory
RUN mkdir -p /app
WORKDIR /app

# Install gems, use cache if possible
COPY Gemfile ./

RUN bundle config --global without development test
RUN bundle config --global clean true
RUN bundle install --jobs 4 --retry 3 --standalone

# Copy application code
COPY . /app
