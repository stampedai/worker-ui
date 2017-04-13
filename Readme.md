# Sidekiq Worker UI

UI for [Sidekiq](http://sidekiq.org/) background workers.

## Getting started

Install gems:

```bash
$ bundle install
```

Copy default environment variables and configure in [.env.local](.env.local):

```bash
$ cp .env.default .env.local && $EDITOR .env.local
```

Start with foreman:

```bash
$ foreman start
```

Or without:

```bash
$ bundle exec dotenv -f .env.local thin -R sidekiq.ru start -p 9292

# In another terminal
$ redis-server
```

Hit the UI on [localhost:9292/sidekiq/](http://localhost:9292/sidekiq)


## Docker

Build the app image:

```bash
$ docker build -t worker-ui .
```

Launch all services and hit [docker:9292/sidekiq](http://docker:9292/sidekiq):

```bash
$ docker-compose up
```

# Based on

- [Sidekiq status](https://github.com/utgarda/sidekiq-status)
