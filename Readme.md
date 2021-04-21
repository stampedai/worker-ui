# Worker UI

UI for [Sidekiq](http://sidekiq.org/) background workers.

## Getting started

Install ruby 2.6.5 (required for the worker-ui to run properly)
```bash
$ asdf install ruby 2.6.5
```

Install gems:

```bash
$ bundle install
```

With Sidekiq Pro:

```bash
$ SIDEKIQ_PRO_KEY=... bundle install
```

Copy default environment variables and configure in [.env.local](.env.local):

```bash
$ cp .env.default .env.local && $EDITOR .env.local
```

Start with overmind:

```bash
$ dotenv -f .env.local overmind start
```

Hit the UI on [localhost:3000](http://localhost:3000)

If you get a `No preset version installed for command dotenv` error when trying to start the workey-ui, even with the correct ruby version install, you might be missing rails:
```bash
$ gem install rails
```

## Configuration

| Name              | Description                                                     | Required | Default                |
|:------------------|:----------------------------------------------------------------|:---------|:-----------------------|
| `PORT`            | Port on which Puma will run                                     | false    | 3000                   |
| `APP_ENV`         | Application environment (`production`, `development` or `test`) | false    | production             |
| `SIDEKIQ_PRO_KEY` | Sidekiq Pro credentials                                         | false    |                        |
| `REDIS_URL`       | Redis URL                                                       | true     | redis://localhost:6379 |

## Docker

Build the app image:

```bash
$ docker build -t worker-ui .
```

With Sidekiq Pro:

```bash
$ docker build --build-arg SIDEKIQ_PRO_KEY=fbfd958a:2633dc73 -t worker-ui-pro .
```

# License

Worker-UI is released under the [MIT License](http://opensource.org/licenses/MIT).
