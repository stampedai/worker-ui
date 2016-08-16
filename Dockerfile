FROM ruby:2.3.1-slim
MAINTAINER p@dialoganalytics.com

# Run updates
RUN apt-get update -qq

# Clean apt
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up app directory
RUN mkdir -p /app
WORKDIR /app

# Install gems, use cache if possible
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 3 --standalone --clean --without development test

# Copy application code
COPY . /app
