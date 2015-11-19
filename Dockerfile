FROM ruby:2.2.3
MAINTAINER philippe.dionne@can-explore.com

# Run updates
# RUN apt-get update -qq && apt-get install -y \
#   build-essential

# Clean apt
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up app directory
RUN mkdir -p /app
WORKDIR /app

# Install gems, use cache if possible
COPY Gemfile Gemfile.lock ./
RUN gem install bundler --no-ri --no-rdoc
RUN bundle install --jobs 20 --retry 3 --standalone --clean --without development test

# Copy application code
COPY . /app
