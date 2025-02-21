# lidarr

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                             | Default             |
|----------------------------------|---------------------|
| LIDARR__ANALYTICS__ENABLED       | `False`             |
| LIDARR__API_KEY                  |                     |
| LIDARR__AUTHENTICATION__METHOD   | `None`              |
| LIDARR__AUTHENTICATION__REQUIRED |                     |
| LIDARR__BRANCH                   | _(current channel)_ |
| LIDARR__INSTANCE__NAME           | `Lidarr`            |
| LIDARR__LOG__LEVEL               | `info`              |
| LIDARR__PORT                     | `8686`              |
| LIDARR__POSTGRES__HOST           |                     |
| LIDARR__POSTGRES__LOG__DB        |                     |
| LIDARR__POSTGRES__MAIN__DB       |                     |
| LIDARR__POSTGRES__PASSWORD       |                     |
| LIDARR__POSTGRES__PORT           | `5432`              |
| LIDARR__POSTGRES__USER           |                     |
| LIDARR__URL__BASE                |                     |
