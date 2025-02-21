# lidarr

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                       | Default                     |
|----------------------------|-----------------------------|
| LIDARR__API_KEY            |                             |
| LIDARR__AUTH__METHOD       | `External`                  |
| LIDARR__AUTH__REQUIRED     | `DisabledForLocalAddresses` |
| LIDARR__UPDATE__BRANCH     | _(current channel)_         |
| LIDARR__APP__INSTANCENAME  | `Lidarr`                    |
| LIDARR__APP__THEME         | `dark`                      |
| LIDARR__LOG__LEVEL         | `info`                      |
| LIDARR__SERVER__PORT       | `8686`                      |
| LIDARR__POSTGRES__HOST     |                             |
| LIDARR__POSTGRES__LOGDB    |                             |
| LIDARR__POSTGRES__MAINDB   |                             |
| LIDARR__POSTGRES__PASSWORD |                             |
| LIDARR__POSTGRES__PORT     | `5432`                      |
| LIDARR__POSTGRES__USER     |                             |
