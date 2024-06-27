# mysql

### Quick reference
快速参考

- **Maintained by**: 维护者
  [the Docker Community and the MySQL Team](https://github.com/docker-library/mysql)
  Docker 社区和 MySQL 团队

- **Where to get help**: 从哪里获得帮助：
  [the Docker Community Slack](https://dockr.ly/comm-slack), [Server Fault](https://serverfault.com/help/on-topic), [Unix & Linux](https://unix.stackexchange.com/help/on-topic), or [Stack Overflow](https://stackoverflow.com/help/on-topic)

### Supported tags and respective `Dockerfile` links
支持的标签和相应的 `Dockerfile` 链接

- [`8.4.0`, `8.4`, `8`, `lts`, `latest`, `innovation`, `8.4.0-oraclelinux9`, `8.4-oraclelinux9`, `8-oraclelinux9`, `lts-oraclelinux9`, `oraclelinux9`, `innovation-oraclelinux9`, `8.4.0-oracle`, `8.4-oracle`, `8-oracle`, `lts-oracle`, `oracle`, `innovation-oracle`](https://github.com/docker-library/mysql/blob/319db566ac7fef45c22f3df15ee5e194a7c43259/8.4/Dockerfile.oracle)

- [`8.0.37`, `8.0`, `8.0.37-oraclelinux9`, `8.0-oraclelinux9`, `8.0.37-oracle`, `8.0-oracle`](https://github.com/docker-library/mysql/blob/319db566ac7fef45c22f3df15ee5e194a7c43259/8.0/Dockerfile.oracle)

- [`8.0.37-bookworm`, `8.0-bookworm`, `8.0.37-debian`, `8.0-debian`](https://github.com/docker-library/mysql/blob/319db566ac7fef45c22f3df15ee5e194a7c43259/8.0/Dockerfile.debian)

### Quick reference (cont.) 快速参考（续）

- **Where to file issues**: 在哪里提交问题：
  [https://github.com/docker-library/mysql/issues](https://github.com/docker-library/mysql/issues?q=)

- **Supported architectures**: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))
  支持的架构：（更多信息）
  [`amd64`](https://hub.docker.com/r/amd64/mysql/), [`arm64v8`](https://hub.docker.com/r/arm64v8/mysql/)

- **Published image artifact details**:
  已发布的图像工件详细信息：
  [repo-info repo's `repos/mysql/` directory](https://github.com/docker-library/repo-info/blob/master/repos/mysql) ([history](https://github.com/docker-library/repo-info/commits/master/repos/mysql))
  repo-info repo 的 `repos/mysql/` 目录（历史记录）
  (image metadata, transfer size, etc)
  （图像元数据、传输大小等）

- **Image updates**: 图片更新：
  [official-images repo's `library/mysql` label
  官方图像存储库的 `library/mysql` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fmysql)
  [official-images repo's `library/mysql` file](https://github.com/docker-library/official-images/blob/master/library/mysql) ([history](https://github.com/docker-library/official-images/commits/master/library/mysql))
  官方图像存储库的 `library/mysql` 文件（历史记录）

- **Source of this description**:
  此描述来源：
  [docs repo's `mysql/` directory](https://github.com/docker-library/docs/tree/master/mysql) ([history](https://github.com/docker-library/docs/commits/master/mysql))
  文档存储库的 `mysql/` 目录（历史记录）

### What is MySQL?
什么是 MySQL？

MySQL is the world's most popular open source database. With its proven performance, reliability and ease-of-use, MySQL has become the leading database choice for web-based applications, covering the entire range from personal projects and websites, via e-commerce and information services, all the way to high profile web properties including Facebook, Twitter, YouTube, Yahoo! and many more.
MySQL 是世界上最流行的开源数据库。凭借其经过验证的性能、可靠性和易用性，MySQL 已成为基于 Web 的应用程序的领先数据库选择，涵盖从个人项目和网站，到电子商务和信息服务，一直到高端应用程序的整个范围。网络资源，包括 Facebook、Twitter、YouTube、Yahoo!还有很多。

For more information and related downloads for MySQL Server and other MySQL products, please visit [www.mysql.com](http://www.mysql.com/).
有关 MySQL Server 和其他 MySQL 产品的更多信息和相关下载，请访问 www.mysql.com。

![logo](https://raw.githubusercontent.com/docker-library/docs/c408469abbac35ad1e4a50a6618836420eb9502e/mysql/logo.png)

### How to use this image
如何使用此图像

#### Start a `mysql` server instance
启动 `mysql` 服务器实例

Starting a MySQL instance is simple:
启动 MySQL 实例很简单：

```console
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
```

... where `some-mysql` is the name you want to assign to your container, `my-secret-pw` is the password to be set for the MySQL root user and `tag` is the tag specifying the MySQL version you want. See the list above for relevant tags.
...其中 `some-mysql` 是要分配给容器的名称， `my-secret-pw` 是要为 MySQL root 用户设置的密码， `tag` 是标签指定您想要的 MySQL 版本。请参阅上面的列表以获取相关标签。

#### Connect to MySQL from the MySQL command line client
从 MySQL 命令行客户端连接到 MySQL

The following command starts another `mysql` container instance and runs the `mysql` command line client against your original `mysql` container, allowing you to execute SQL statements against your database instance:
以下命令启动另一个 `mysql` 容器实例，并对原始 `mysql` 容器运行 `mysql` 命令行客户端，从而允许您对数据库实例执行 SQL 语句：

```console
$ docker run -it --network some-network --rm mysql mysql -hsome-mysql -uexample-user -p
```

... where `some-mysql` is the name of your original `mysql` container (connected to the `some-network` Docker network).
...其中 `some-mysql` 是原始 `mysql` 容器的名称（连接到 `some-network` Docker 网络）。

This image can also be used as a client for non-Docker or remote instances:
该镜像还可以用作非 Docker 或远程实例的客户端：

```console
$ docker run -it --rm mysql mysql -hsome.mysql.host -usome-mysql-user -p
```

More information about the MySQL command line client can be found in the [MySQL documentation](http://dev.mysql.com/doc/en/mysql.html)
有关 MySQL 命令行客户端的更多信息可以在 MySQL 文档中找到

#### ... via [`docker-compose`](https://github.com/docker/compose) or [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/)
...通过 `docker-compose` 或 `docker stack deploy`

Example `docker-compose.yml` for `mysql`:
`mysql` 的 `docker-compose.yml` 示例：

```yaml
# Use root/example as user/password credentials
version: '3.1'

services:

  db:
    image: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
    # (this is just an example, not intended to be a production configuration)
```

Run `docker stack deploy -c stack.yml mysql` (or `docker-compose -f stack.yml up`), wait for it to initialize completely, and visit `http://swarm-ip:8080`, `http://localhost:8080`, or `http://host-ip:8080` (as appropriate).
运行 `docker stack deploy -c stack.yml mysql` （或 `docker-compose -f stack.yml up` ），等待其完全初始化，然后访问 `http://swarm-ip:8080` 、 `http://localhost:8080` 或 `http://host-ip:8080`

#### Container shell access and viewing MySQL logs
容器shell访问并查看MySQL日志

The `docker exec` command allows you to run commands inside a Docker container. The following command line will give you a bash shell inside your `mysql` container:
`docker exec` 命令允许您在 Docker 容器内运行命令。以下命令行将为您提供 `mysql` 容器内的 bash shell：

```console
$ docker exec -it some-mysql bash
```

The log is available through Docker's container log:
该日志可以通过Docker的容器日志获得：

```console
$ docker logs some-mysql
```

#### Using a custom MySQL configuration file
使用自定义 MySQL 配置文件

The default configuration for MySQL can be found in `/etc/mysql/my.cnf`, which may `!includedir` additional directories such as `/etc/mysql/conf.d` or `/etc/mysql/mysql.conf.d`. Please inspect the relevant files and directories within the `mysql` image itself for more details.  
MySQL 的默认配置可以在 `/etc/mysql/my.cnf` 中找到，其中可能有 `!includedir` 其他目录，例如 `/etc/mysql/conf.d` 或 `/etc/mysql/mysql.conf.d` 。请检查 `mysql` 图像本身内的相关文件和目录以获取更多详细信息。

If `/my/custom/config-file.cnf` is the path and name of your custom configuration file, you can start your `mysql` container like this (note that only the directory path of the custom config file is used in this command):
如果 `/my/custom/config-file.cnf` 是自定义配置文件的路径和名称，则可以像这样启动 `mysql` 容器（请注意，此命令中仅使用自定义配置文件的目录路径）：

```console
$ docker run --name some-mysql -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
```

This will start a new container `some-mysql` where the MySQL instance uses the combined startup settings from `/etc/mysql/my.cnf` and `/etc/mysql/conf.d/config-file.cnf`, with settings from the latter taking precedence.
这将启动一个新容器 `some-mysql` ，其中 MySQL 实例使用 `/etc/mysql/my.cnf` 和 `/etc/mysql/conf.d/config-file.cnf` 的组合启动设置，后者的设置优先。

##### Configuration without a `cnf` file
没有 `cnf` 文件的配置

Many configuration options can be passed as flags to `mysqld`. This will give you the flexibility to customize the container without needing a `cnf` file. For example, if you want to change the default encoding and collation for all tables to use UTF-8 (`utf8mb4`) just run the following:
许多配置选项可以作为标志传递给 `mysqld` 。这将使您能够灵活地自定义容器，而无需 `cnf` 文件。例如，如果您想要更改所有表的默认编码和排序规则以使用 UTF-8 ( `utf8mb4` )，只需运行以下命令：

```console
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```

If you would like to see a complete list of available options, just run:
如果您想查看可用选项的完整列表，只需运行：

```console
$ docker run -it --rm mysql:tag --verbose --help
```

#### Environment Variables
环境变量

When you start the `mysql` image, you can adjust the configuration of the MySQL instance by passing one or more environment variables on the `docker run` command line. Do note that none of the variables below will have any effect if you start the container with a data directory that already contains a database: any pre-existing database will always be left untouched on container startup.
当您启动 `mysql` 镜像时，您可以通过在 `docker run` 命令行上传递一个或多个环境变量来调整MySQL实例的配置。请注意，如果您使用已包含数据库的数据目录启动容器，则以下任何变量都不会产生任何影响：任何预先存在的数据库在容器启动时将始终保持不变。

See also https://dev.mysql.com/doc/refman/5.7/en/environment-variables.html for documentation of environment variables which MySQL itself respects (especially variables like `MYSQL_HOST`, which is known to cause issues when used with this image).
另请参阅 https://dev.mysql.com/doc/refman/5.7/en/environment-variables.html 了解 MySQL 本身所遵循的环境变量的文档（尤其是像 `MYSQL_HOST` 这样的变量，众所周知与此图像一起使用时会导致问题）。

##### `MYSQL_ROOT_PASSWORD`

This variable is mandatory and specifies the password that will be set for the MySQL `root` superuser account. In the above example, it was set to `my-secret-pw`.
此变量是必需的，指定将为 MySQL `root` 超级用户帐户设置的密码。在上面的示例中，它被设置为 `my-secret-pw` 。

##### `MYSQL_DATABASE`

This variable is optional and allows you to specify the name of a database to be created on image startup. If a user/password was supplied (see below) then that user will be granted superuser access ([corresponding to `GRANT ALL`](https://dev.mysql.com/doc/refman/en/creating-accounts.html)) to this database.
该变量是可选的，允许您指定要在映像启动时创建的数据库的名称。如果提供了用户/密码（见下文），则该用户将被授予对此数据库的超级用户访问权限（对应于 `GRANT ALL` ）。

##### `MYSQL_USER`, `MYSQL_PASSWORD`

These variables are optional, used in conjunction to create a new user and to set that user's password. This user will be granted superuser permissions (see above) for the database specified by the `MYSQL_DATABASE` variable. Both variables are required for a user to be created.
这些变量是可选的，结合使用来创建新用户并设置该用户的密码。该用户将被授予由 `MYSQL_DATABASE` 变量指定的数据库的超级用户权限（见上文）。创建用户需要这两个变量。

Do note that there is no need to use this mechanism to create the root superuser, that user gets created by default with the password specified by the `MYSQL_ROOT_PASSWORD` variable.
请注意，无需使用此机制来创建 root 超级用户，默认情况下会使用 `MYSQL_ROOT_PASSWORD` 变量指定的密码创建该用户。

##### `MYSQL_ALLOW_EMPTY_PASSWORD`

This is an optional variable. Set to a non-empty value, like `yes`, to allow the container to be started with a blank password for the root user. *NOTE*: Setting this variable to `yes` is not recommended unless you really know what you are doing, since this will leave your MySQL instance completely unprotected, allowing anyone to gain complete superuser access.
这是一个可选变量。设置为非空值，例如 `yes` ，以允许使用 root 用户的空白密码启动容器。注意：除非您确实知道自己在做什么，否则不建议将此变量设置为 `yes` ，因为这将使您的 MySQL 实例完全不受保护，从而允许任何人获得完全的超级用户访问权限。

##### `MYSQL_RANDOM_ROOT_PASSWORD`

This is an optional variable. Set to a non-empty value, like `yes`, to generate a random initial password for the root user (using `pwgen`). The generated root password will be printed to stdout (`GENERATED ROOT PASSWORD: .....`).
这是一个可选变量。设置为非空值，例如 `yes` ，为 root 用户生成随机初始密码（使用 `pwgen` ）。生成的 root 密码将打印到 stdout ( `GENERATED ROOT PASSWORD: .....` )。

##### `MYSQL_ONETIME_PASSWORD`

Sets root (*not* the user specified in `MYSQL_USER`!) user as expired once init is complete, forcing a password change on first login. Any non-empty value will activate this setting. *NOTE*: This feature is supported on MySQL 5.6+ only. Using this option on MySQL 5.5 will throw an appropriate error during initialization.
初始化完成后，将 root（不是 `MYSQL_USER` 中指定的用户！）用户设置为过期，强制在首次登录时更改密码。任何非空值都将激活此设置。注意：此功能仅在 MySQL 5.6+ 上受支持。在 MySQL 5.5 上使用此选项将在初始化期间引发相应的错误。

##### `MYSQL_INITDB_SKIP_TZINFO`

By default, the entrypoint script automatically loads the timezone data needed for the `CONVERT_TZ()` function. If it is not needed, any non-empty value disables timezone loading.
默认情况下，入口点脚本会自动加载 `CONVERT_TZ()` 函数所需的时区数据。如果不需要，任何非空值都会禁用时区加载。

#### Docker Secrets
Docker 的秘密

As an alternative to passing sensitive information via environment variables, `_FILE` may be appended to the previously listed environment variables, causing the initialization script to load the values for those variables from files present in the container. In particular, this can be used to load passwords from Docker secrets stored in `/run/secrets/<secret_name>` files. For example:
作为通过环境变量传递敏感信息的替代方法，可以将 `_FILE` 附加到先前列出的环境变量，从而使初始化脚本从容器中存在的文件加载这些变量的值。特别是，这可用于从存储在 `/run/secrets/<secret_name>` 文件中的 Docker 机密加载密码。例如：

```console
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-root -d mysql:tag
```

Currently, this is only supported for `MYSQL_ROOT_PASSWORD`, `MYSQL_ROOT_HOST`, `MYSQL_DATABASE`, `MYSQL_USER`, and `MYSQL_PASSWORD`.
目前，仅支持 `MYSQL_ROOT_PASSWORD` 、 `MYSQL_ROOT_HOST` 、 `MYSQL_DATABASE` 、 `MYSQL_USER` 和 `MYSQL_PASSWORD` 。

### Initializing a fresh instance
初始化一个新实例

When a container is started for the first time, a new database with the specified name will be created and initialized with the provided configuration variables. Furthermore, it will execute files with extensions `.sh`, `.sql` and `.sql.gz` that are found in `/docker-entrypoint-initdb.d`. Files will be executed in alphabetical order. You can easily populate your `mysql` services by [mounting a SQL dump into that directory](https://docs.docker.com/storage/bind-mounts/) and provide [custom images](https://docs.docker.com/reference/dockerfile/) with contributed data. SQL files will be imported by default to the database specified by the `MYSQL_DATABASE` variable.
当容器第一次启动时，将创建一个具有指定名称的新数据库，并使用提供的配置变量进行初始化。此外，它将执行在 `/docker-entrypoint-initdb.d` 中找到的扩展名为 `.sh` 、 `.sql` 和 `.sql.gz` 的文件。文件将按字母顺序执行。您可以通过将 SQL 转储安装到该目录中来轻松填充您的 `mysql` 服务，并提供带有贡献数据的自定义映像。默认情况下，SQL 文件将导入到 `MYSQL_DATABASE` 变量指定的数据库中。

### Caveats
注意事项

#### Where to Store Data
在哪里存储数据

Important note: There are several ways to store data used by applications that run in Docker containers. We encourage users of the `mysql` images to familiarize themselves with the options available, including:
重要提示：有多种方法可以存储在 Docker 容器中运行的应用程序使用的数据。我们鼓励 `mysql` 图像的用户熟悉可用的选项，包括：

- Let Docker manage the storage of your database data [by writing the database files to disk on the host system using its own internal volume management](https://docs.docker.com/storage/volumes/). This is the default and is easy and fairly transparent to the user. The downside is that the files may be hard to locate for tools and applications that run directly on the host system, i.e. outside containers.
  让 Docker 通过使用其自己的内部卷管理将数据库文件写入主机系统上的磁盘来管理数据库数据的存储。这是默认设置，对于用户来说很简单且相当透明。缺点是对于直接在主机系统（即外部容器）上运行的工具和应用程序来说，可能很难找到这些文件。

- Create a data directory on the host system (outside the container) and [mount this to a directory visible from inside the container](https://docs.docker.com/storage/bind-mounts/). This places the database files in a known location on the host system, and makes it easy for tools and applications on the host system to access the files. The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly.
  在主机系统（容器外部）上创建一个数据目录，并将其挂载到容器内部可见的目录中。这会将数据库文件放置在主机系统上的已知位置，并使主机系统上的工具和应用程序可以轻松访问这些文件。缺点是用户需要确保该目录存在，并且例如主机系统上的目录权限和其他安全机制已正确设置。

The Docker documentation is a good starting point for understanding the different storage options and variations, and there are multiple blogs and forum postings that discuss and give advice in this area. We will simply show the basic procedure here for the latter option above:
Docker 文档是了解不同存储选项和变体的一个很好的起点，并且有多个博客和论坛帖子讨论了该领域并提供了建议。我们将在这里简单地展示上面后一个选项的基本过程：

1. Create a data directory on a suitable volume on your host system, e.g. `/my/own/datadir`.
   在主机系统上合适的卷上创建数据目录，例如 `/my/own/datadir` 。

2. Start your `mysql` container like this:
   像这样启动你的 `mysql` 容器：

   ```console
   $ docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
   ```

The `-v /my/own/datadir:/var/lib/mysql` part of the command mounts the `/my/own/datadir` directory from the underlying host system as `/var/lib/mysql` inside the container, where MySQL by default will write its data files.
该命令的 `-v /my/own/datadir:/var/lib/mysql` 部分将底层主机系统中的 `/my/own/datadir` 目录挂载为容器内的 `/var/lib/mysql` ，默认情况下 MySQL 将在其中写入其数据文件。

#### No connections until MySQL init completes
MySQL 初始化完成之前没有连接

If there is no database initialized when the container starts, then a default database will be created. While this is the expected behavior, this means that it will not accept incoming connections until such initialization completes. This may cause issues when using automation tools, such as `docker-compose`, which start several containers simultaneously.
如果容器启动时没有初始化数据库，则会创建一个默认数据库。虽然这是预期的行为，但这意味着在初始化完成之前它不会接受传入连接。在使用自动化工具（例如同时启动多个容器的 `docker-compose` ）时，这可能会导致问题。

If the application you're trying to connect to MySQL does not handle MySQL downtime or waiting for MySQL to start gracefully, then putting a connect-retry loop before the service starts might be necessary. For an example of such an implementation in the official images, see [WordPress](https://github.com/docker-library/wordpress/blob/1b48b4bccd7adb0f7ea1431c7b470a40e186f3da/docker-entrypoint.sh#L195-L235) or [Bonita](https://github.com/docker-library/docs/blob/9660a0cccb87d8db842f33bc0578d769caaf3ba9/bonita/stack.yml#L28-L44).
如果您尝试连接到 MySQL 的应用程序无法处理 MySQL 停机或等待 MySQL 正常启动，则可能需要在服务启动之前放置一个连接重试循环。有关官方镜像中此类实现的示例，请参阅 WordPress 或 Bonita。

#### Usage against an existing database
针对现有数据库的使用

If you start your `mysql` container instance with a data directory that already contains a database (specifically, a `mysql` subdirectory), the `$MYSQL_ROOT_PASSWORD` variable should be omitted from the run command line; it will in any case be ignored, and the pre-existing database will not be changed in any way.
如果您使用已包含数据库的数据目录（特别是 `mysql` 子目录）启动 `mysql` 容器实例，则应从运行命令行；在任何情况下它都会被忽略，并且预先存在的数据库不会以任何方式改变。

#### Running as an arbitrary user
以任意用户身份运行

If you know the permissions of your directory are already set appropriately (such as running against an existing database, as described above) or you have need of running `mysqld` with a specific UID/GID, it is possible to invoke this image with `--user` set to any value (other than `root`/`0`) in order to achieve the desired access/configuration:
如果您知道目录的权限已正确设置（例如针对现有数据库运行，如上所述），或者您需要使用特定 UID/GID 运行 `mysqld` ，则可以调用该图像将 `--user` 设置为任何值（ `root` / `0` 除外），以实现所需的访问/配置：

```console
$ mkdir data
$ ls -lnd data
drwxr-xr-x 2 1000 1000 4096 Aug 27 15:54 data
$ docker run -v "$PWD/data":/var/lib/mysql --user 1000:1000 --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
```

#### Creating database dumps
创建数据库转储

Most of the normal tools will work, although their usage might be a little convoluted in some cases to ensure they have access to the `mysqld` server. A simple way to ensure this is to use `docker exec` and run the tool from the same container, similar to the following:
大多数普通工具都可以工作，尽管在某些情况下它们的使用可能有点复杂，以确保它们能够访问 `mysqld` 服务器。确保这一点的一个简单方法是使用 `docker exec` 并从同一容器运行该工具，类似于以下内容：

```console
$ docker exec some-mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql
```

#### Restoring data from dump files
从转储文件中恢复数据

For restoring data. You can use `docker exec` command with `-i` flag, similar to the following:
用于恢复数据。您可以使用带有 `-i` 标志的 `docker exec` 命令，类似于以下内容：

```console
$ docker exec -i some-mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < /some/path/on/your/host/all-databases.sql
```

### License
执照

View [license information](https://www.mysql.com/about/legal/) for the software contained in this image.
查看此映像中包含的软件的许可证信息。

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
与所有 Docker 映像一样，这些映像可能还包含可能受其他许可的其他软件（例如基础发行版中的 Bash 等，以及所包含的主要软件的任何直接或间接依赖项）。

Some additional license information which was able to be auto-detected might be found in [the `repo-info` repository's `mysql/` directory](https://github.com/docker-library/repo-info/tree/master/repos/mysql).
可以在 `repo-info` 存储库的 `mysql/` 目录中找到一些能够自动检测的附加许可证信息。

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
对于任何预构建图像的使用，图像用户有责任确保对此图像的任何使用均符合其中包含的所有软件的任何相关许可。
