#!/bin/bash
# set -x
set -eo pipefail
shopt -s nullglob

# logging functions
mysql_log() {
	local type="$1"
	shift
	# accept argument string or stdin
	local text="$*"
	if [ "$#" -eq 0 ]; then text="$(cat)"; fi
	local dt
	dt="$(date --rfc-3339=seconds)"
	printf '%s [%s] [Entrypoint]: %s\n' "$dt" "$type" "$text"
}
mysql_note() {
	mysql_log Note "$@"
}
mysql_warn() {
	mysql_log Warn "$@" >&2
}
mysql_error() {
	mysql_log ERROR "$@" >&2
	exit 1
}

# file_env MYSQL_ROOT_HOST %
# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	echo "file_env @: $@"
	local var="$1"
	# local var=MYSQL_ROOT_HOST

	local fileVar="${var}_FILE"
	# local fileVar=MYSQL_ROOT_HOST_FILE

	local def="${2:-}"
	# local def=%

	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		mysql_error "Both $var and $fileVar are set (but are exclusive)"
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(<"${!fileVar}")"
	fi
	echo "file_env var: $var"
	echo "file_env fileVar: $fileVar"
	echo "file_env def: $def"
	echo "file_env val: $val"
	export "$var"="$val"
	unset "$fileVar"

	# file_env @: MYSQL_ROOT_HOST %
	# file_env var: MYSQL_ROOT_HOST
	# file_env fileVar: MYSQL_ROOT_HOST_FILE
	# file_env def: %
	# file_env val: %

	# file_env @: MYSQL_DATABASE
	# file_env var: MYSQL_DATABASE
	# file_env fileVar: MYSQL_DATABASE_FILE
	# file_env def:
	# file_env val:

	# file_env @: MYSQL_USER
	# file_env var: MYSQL_USER
	# file_env fileVar: MYSQL_USER_FILE
	# file_env def:
	# file_env val:

	# file_env @: MYSQL_PASSWORD
	# file_env var: MYSQL_PASSWORD
	# file_env fileVar: MYSQL_PASSWORD_FILE
	# file_env def:
	# file_env val:

	# file_env @: MYSQL_ROOT_PASSWORD
	# file_env var: MYSQL_ROOT_PASSWORD
	# file_env fileVar: MYSQL_ROOT_PASSWORD_FILE
	# file_env def:
	# file_env val: my-secret-pw

}

# check to see if this file is being run or sourced from another script
_is_sourced() {
	echo "_is_sourced FUNCNAME[@]: ${#FUNCNAME[@]}"
	echo "_is_sourced FUNCNAME[0]: ${FUNCNAME[0]}"
	echo "_is_sourced FUNCNAME[1]: ${FUNCNAME[1]}"
	# FUNCNAME[@]: 2
	# FUNCNAME[0]: _is_sourced
	# FUNCNAME[1]: main

	# https://unix.stackexchange.com/a/215279
	[ "${#FUNCNAME[@]}" -ge 2 ] &&
		[ "${FUNCNAME[0]}" = '_is_sourced' ] &&
		[ "${FUNCNAME[1]}" = 'source' ]
}

# usage: docker_process_init_files [file [file [...]]]
#    ie: docker_process_init_files /always-initdb.d/*
# process initializer files, based on file extensions
docker_process_init_files() {
	echo "docker_process_init_files @: $@"
	# docker_process_init_files @:

	# mysql here for backwards compatibility "${mysql[@]}"
	mysql=(docker_process_sql)

	echo
	local f
	for f; do
		echo "docker_process_init_files f: $f"
		case "$f" in
		*.sh)
			# https://github.com/docker-library/postgres/issues/450#issuecomment-393167936
			# https://github.com/docker-library/postgres/pull/452
			if [ -x "$f" ]; then
				mysql_note "$0: running $f"
				"$f"
			else
				mysql_note "$0: sourcing $f"
				. "$f"
			fi
			;;
		*.sql)
			mysql_note "$0: running $f"
			docker_process_sql <"$f"
			echo
			;;
		*.sql.bz2)
			mysql_note "$0: running $f"
			bunzip2 -c "$f" | docker_process_sql
			echo
			;;
		*.sql.gz)
			mysql_note "$0: running $f"
			gunzip -c "$f" | docker_process_sql
			echo
			;;
		*.sql.xz)
			mysql_note "$0: running $f"
			xzcat "$f" | docker_process_sql
			echo
			;;
		*.sql.zst)
			mysql_note "$0: running $f"
			zstd -dc "$f" | docker_process_sql
			echo
			;;
		*) mysql_warn "$0: ignoring $f" ;;
		esac
		echo
	done
}

# arguments necessary to run "mysqld --verbose --help" successfully (used for testing configuration validity and for extracting default/configured values)
_verboseHelpArgs=(
	--verbose --help
	--log-bin-index="$(mktemp -u)" # https://github.com/docker-library/mysql/issues/136
)
# ++ mktemp -u
# + _verboseHelpArgs=(--verbose --help --log-bin-index="$(mktemp -u)")
# for i in ${_verboseHelpArgs[*]}; do
# 	echo $i
# done
# # + _verboseHelpArgs=(--verbose --help --log-bin-index="$(mktemp -u)")
# # ++ mktemp -u
# # + for i in ${_verboseHelpArgs[*]}
# # + echo --verbose
# # + for i in ${_verboseHelpArgs[*]}
# # --verbose
# # + echo --help
# # --help
# # + for i in ${_verboseHelpArgs[*]}
# # --log-bin-index=/tmp/tmp.xu0ILaEK2Z
# # + echo --log-bin-index=/tmp/tmp.xu0ILaEK2Z

# mysql_check_config mysqld
mysql_check_config() {
	echo "mysql_check_config @: $@"
	# mysql_check_config @: mysqld

	for i in ${_verboseHelpArgs[*]}; do
		echo "mysql_check_config: $i"
	done
	# mysql_check_config: --verbose
	# mysql_check_config: --help
	# mysql_check_config: --log-bin-index=/tmp/tmp.RQqVLtU0ep

	local toRun=("$@" "${_verboseHelpArgs[@]}") errors
	for i in ${toRun[*]}; do
		echo "toRun: $i"
	done
	# toRun: mysqld
	# toRun: --verbose
	# toRun: --help
	# toRun: --log-bin-index=/tmp/tmp.RQqVLtU0ep

	# ++ mysqld --verbose --help --log-bin-index=/tmp/tmp.7NhdQTKbtY
	# + errors=
	if ! errors="$("${toRun[@]}" 2>&1 >/dev/null)"; then
		mysql_error $'mysqld failed while attempting to check config\n\tcommand was: '"${toRun[*]}"$'\n\t'"$errors"
	fi
}

# mysql_get_config datadir mysqld
# Fetch value from server config
# We use mysqld --verbose --help instead of my_print_defaults because the
# latter only show values present in config files, and not server defaults
mysql_get_config() {
	set -x

	local conf="$1"
	shift

	"$@" "${_verboseHelpArgs[@]}" 2>/dev/null |
		awk -v conf="$conf" '$1 == conf && /^[^ \t]/ { sub(/^[^ \t]+[ \t]+/, ""); print; exit }'
	# match "datadir      /some/path with/spaces in/it here" but not "--xyz=abc\n     datadir (xyz)"

	# mysqld --verbose --help --log-bin-index=/tmp/tmp.qFuF2MP6RO
	# awk -v conf=datadir '$1 == conf && /^[^ \t]/ { sub(/^[^ \t]+[ \t]+/, ""); print; exit }'

	# mysqld --verbose --help --log-bin-index=/tmp/tmp.qFuF2MP6RO
	# awk -v conf=socket '$1 == conf && /^[^ \t]/ { sub(/^[^ \t]+[ \t]+/, ""); print; exit }'

	# mysqld --verbose --help --log-bin-index=/tmp/tmp.qFuF2MP6RO
	# awk -v conf=general-log-file '$1 == conf && /^[^ \t]/ { sub(/^[^ \t]+[ \t]+/, ""); print; exit }'

	# mysqld --verbose --help --log-bin-index=/tmp/tmp.qFuF2MP6RO
	# awk -v conf=keyring_file_data '$1 == conf && /^[^ \t]/ { sub(/^[^ \t]+[ \t]+/, ""); print; exit }'

	# mysqld --verbose --help --log-bin-index=/tmp/tmp.qFuF2MP6RO
	# awk -v conf=pid-file '$1 == conf && /^[^ \t]/ { sub(/^[^ \t]+[ \t]+/, ""); print; exit }'

	# mysqld --verbose --help --log-bin-index=/tmp/tmp.qFuF2MP6RO
	# awk -v conf=secure-file-priv '$1 == conf && /^[^ \t]/ { sub(/^[^ \t]+[ \t]+/, ""); print; exit }'

	# mysqld --verbose --help --log-bin-index=/tmp/tmp.qFuF2MP6RO
	# awk -v conf=slow-query-log-file '$1 == conf && /^[^ \t]/ { sub(/^[^ \t]+[ \t]+/, ""); print; exit }'

	set +x

}

# mysql_socket_fix
# Ensure that the package default socket can also be used
# since rpm packages are compiled with a different socket location
# and "mysqlsh --mysql" doesn't read the [client] config
# related to https://github.com/docker-library/mysql/issues/829
mysql_socket_fix() {
	local defaultSocket
	defaultSocket="$(mysql_get_config 'socket' mysqld --no-defaults)"
	# defaultSocket=/var/run/mysqld/mysqld.sock
	if [ "$defaultSocket" != "$SOCKET" ]; then
		ln -sfTv "$SOCKET" "$defaultSocket" || :
	fi
}

# docker_temp_server_start mysqld
# Do a temporary startup of the MySQL server, for init purposes
docker_temp_server_start() {
	echo "docker_temp_server_start @: $@"
	# docker_temp_server_start @: mysqld

	echo "docker_temp_server_start SOCKET: $SOCKET"
	# docker_temp_server_start SOCKET: /var/run/mysqld/mysqld.sock

	# For 5.7+ the server is ready for use as soon as startup command unblocks
	if ! "$@" --daemonize --skip-networking --default-time-zone=SYSTEM --socket="${SOCKET}"; then
		# + mysqld --daemonize --skip-networking --default-time-zone=SYSTEM --socket=/var/run/mysqld/mysqld.sock
		mysql_error "Unable to start server."
	fi
}

# Stop the server. When using a local socket file mysqladmin will block until
# the shutdown is complete.
docker_temp_server_stop() {
	set -x
	# mysqladmin --defaults-extra-file=/dev/fd/63 shutdown -uroot --socket=/var/run/mysqld/mysqld.sock
	# _mysql_passfile
	if ! mysqladmin --defaults-extra-file=<(_mysql_passfile) shutdown -uroot --socket="${SOCKET}"; then
		mysql_error "Unable to shut down server."
	fi
	set +x
}

# docker_verify_minimum_env
# Verify that the minimally required password settings are set for new databases.
docker_verify_minimum_env() {
	echo "docker_verify_minimum_env------------"
	env
	echo "docker_verify_minimum_env------------"
	# docker_verify_minimum_env------------
	# MYSQL_MAJOR=8.0
	# HOSTNAME=9e6078be1db7
	# PWD=/
	# MYSQL_ROOT_PASSWORD=my-secret-pw
	# MYSQL_PASSWORD=
	# MYSQL_USER=
	# HOME=/home/mysql
	# MYSQL_VERSION=8.0.37-1debian12
	# GOSU_VERSION=1.17
	# MYSQL_ROOT_HOST=%
	# SHLVL=1
	# MYSQL_DATABASE=
	# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
	# _=/usr/bin/env
	# docker_verify_minimum_env------------

	if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
		mysql_error <<-'EOF'
			Database is uninitialized and password option is not specified
			    You need to specify one of the following as an environment variable:
			    - MYSQL_ROOT_PASSWORD
			    - MYSQL_ALLOW_EMPTY_PASSWORD
			    - MYSQL_RANDOM_ROOT_PASSWORD
		EOF
	fi

	# This will prevent the CREATE USER from failing (and thus exiting with a half-initialized database)
	if [ "$MYSQL_USER" = 'root' ]; then
		mysql_error <<-'EOF'
			MYSQL_USER="root", MYSQL_USER and MYSQL_PASSWORD are for configuring a regular user and cannot be used for the root user
			    Remove MYSQL_USER="root" and use one of the following to control the root user password:
			    - MYSQL_ROOT_PASSWORD
			    - MYSQL_ALLOW_EMPTY_PASSWORD
			    - MYSQL_RANDOM_ROOT_PASSWORD
		EOF
	fi

	# warn when missing one of MYSQL_USER or MYSQL_PASSWORD
	if [ -n "$MYSQL_USER" ] && [ -z "$MYSQL_PASSWORD" ]; then
		mysql_warn 'MYSQL_USER specified, but missing MYSQL_PASSWORD; MYSQL_USER will not be created'
	elif [ -z "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
		mysql_warn 'MYSQL_PASSWORD specified, but missing MYSQL_USER; MYSQL_PASSWORD will be ignored'
	fi
}

# docker_create_db_directories mysqld
# creates folders for the database
# also ensures permission for user mysql of run as root
docker_create_db_directories() {
	local user
	user="$(id -u)"
	# + local user
	# ++ id -u
	# + user=0

	local -A dirs=(["$DATADIR"]=1)
	# + dirs=(['/var/lib/mysql/']='1')

	local dir
	dir="$(dirname "$SOCKET")"
	# + local dir
	# ++ dirname /var/run/mysqld/mysqld.sock
	# + dir=/var/run/mysqld

	dirs["$dir"]=1

	# "datadir" and "socket" are already handled above (since they were already queried previously)
	local conf
	for conf in \
		general-log-file \
		keyring_file_data \
		pid-file \
		secure-file-priv \
		slow-query-log-file; do

		echo "docker_create_db_directories: $conf"
		# docker_create_db_directories: general-log-file
		# docker_create_db_directories: keyring_file_data
		# docker_create_db_directories: pid-file
		# docker_create_db_directories: secure-file-priv
		# docker_create_db_directories: slow-query-log-file

		dir="$(mysql_get_config "$conf" "$@")"
		echo "docker_create_db_directories: $dir"
		# docker_create_db_directories: /var/lib/mysql/9e6078be1db7.log
		# docker_create_db_directories:
		# docker_create_db_directories: /var/run/mysqld/mysqld.pid
		# docker_create_db_directories: NULL
		# docker_create_db_directories: /var/lib/mysql/9e6078be1db7-slow.log

		# skip empty values
		if [ -z "$dir" ] || [ "$dir" = 'NULL' ]; then
			continue
		fi
		case "$conf" in
		secure-file-priv)
			# already points at a directory
			;;
		*)
			# other config options point at a file, but we need the directory
			dir="$(dirname "$dir")"
			;;
		esac

		dirs["$dir"]=1
	done

	set -x
	mkdir -p "${!dirs[@]}"
	# mkdir -p /var/lib/mysql/ /var/run/mysqld /var/lib/mysql

	if [ "$user" = "0" ]; then
		# this will cause less disk access than `chown -R`
		find "${!dirs[@]}" \! -user mysql -exec chown --no-dereference mysql '{}' +
		# find /var/lib/mysql/ /var/run/mysqld /var/lib/mysql '!' -user mysql -exec chown --no-dereference mysql '{}' +
	fi
	set +x
}

# docker_init_database_dir mysqld
# initializes the database directory
docker_init_database_dir() {
	echo "docker_init_database_dir @: $@"
	# docker_init_database_dir @: mysqld

	mysql_note "Initializing database files"
	"$@" --initialize-insecure --default-time-zone=SYSTEM --autocommit=1
	# mysqld --initialize-insecure --default-time-zone=SYSTEM --autocommit=1
	# explicitly enable autocommit to combat https://bugs.mysql.com/bug.php?id=110535 (TODO remove this when 8.0 is EOL; see https://github.com/mysql/mysql-server/commit/7dbf4f80ed15f3c925cfb2b834142f23a2de719a)
	mysql_note "Database files initialized"
}

# + docker_setup_env mysqld
# Loads various settings that are used elsewhere in the script
# This should be called after mysql_check_config, but before any other functions
docker_setup_env() {
	# Get config
	declare -g DATADIR SOCKET
	DATADIR="$(mysql_get_config 'datadir' "$@")"
	echo "docker_setup_env DATADIR $DATADIR"
	# docker_setup_env DATADIR /var/lib/mysql/

	SOCKET="$(mysql_get_config 'socket' "$@")"
	echo "docker_setup_env SOCKET $SOCKET"
	# docker_setup_env SOCKET /var/run/mysqld/mysqld.sock

	# Initialize values that might be stored in a file
	file_env 'MYSQL_ROOT_HOST' '%'
	file_env 'MYSQL_DATABASE'
	file_env 'MYSQL_USER'
	file_env 'MYSQL_PASSWORD'
	file_env 'MYSQL_ROOT_PASSWORD'

	echo "docker_setup_env----------------"
	env
	echo "docker_setup_env----------------"
	# docker_setup_env----------------
	# MYSQL_MAJOR=8.0
	# HOSTNAME=9e6078be1db7
	# PWD=/
	# MYSQL_ROOT_PASSWORD=my-secret-pw
	# MYSQL_PASSWORD=
	# MYSQL_USER=
	# HOME=/root
	# MYSQL_VERSION=8.0.37-1debian12
	# GOSU_VERSION=1.17
	# MYSQL_ROOT_HOST=%
	# SHLVL=1
	# MYSQL_DATABASE=
	# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
	# _=/usr/bin/env
	# docker_setup_env----------------

	declare -g DATABASE_ALREADY_EXISTS

	# + '[' -d /var/lib/mysql//mysql ']'
	if [ -d "$DATADIR/mysql" ]; then
		DATABASE_ALREADY_EXISTS='true'
	fi
	echo "docker_setup_env DATABASE_ALREADY_EXISTS $DATABASE_ALREADY_EXISTS"
	# docker_setup_env DATABASE_ALREADY_EXISTS

}

# Execute sql script, passed via stdin
# usage: docker_process_sql [--dont-use-mysql-root-password] [mysql-cli-args]
#    ie: docker_process_sql --database=mydb <<<'INSERT ...'
#    ie: docker_process_sql --dont-use-mysql-root-password --database=mydb <my-file.sql
docker_process_sql() {
	echo "docker_process_sql1 @: $@"
	# docker_process_sql @: --dont-use-mysql-root-password --database=mysql

	passfileArgs=()
	if [ '--dont-use-mysql-root-password' = "$1" ]; then
		passfileArgs+=("$1")
		shift
	fi
	# args sent in can override this db, since they will be later in the command
	if [ -n "$MYSQL_DATABASE" ]; then
		set -- --database="$MYSQL_DATABASE" "$@"
	fi

	echo "docker_process_sql2 @: $@"
	# docker_process_sql @: --database=mysql

	set -x
	mysql --defaults-extra-file=<(_mysql_passfile "${passfileArgs[@]}") --protocol=socket -uroot -hlocalhost --socket="${SOCKET}" --comments "$@"
	# mysql --defaults-extra-file=/dev/fd/63 --protocol=socket -uroot -hlocalhost --socket=/var/run/mysqld/mysqld.sock --comments --database=mysql
	# _mysql_passfile --dont-use-mysql-root-password

	set +x
}

# docker_setup_db
# Initializes database with timezone info and root password, plus optional extra db/user
docker_setup_db() {
	echo "docker_setup_db MYSQL_INITDB_SKIP_TZINFO: $MYSQL_INITDB_SKIP_TZINFO"
	# docker_setup_db MYSQL_INITDB_SKIP_TZINFO:
	# Load timezone info into database
	if [ -z "$MYSQL_INITDB_SKIP_TZINFO" ]; then
		# sed is for https://bugs.mysql.com/bug.php?id=20545
		mysql_tzinfo_to_sql /usr/share/zoneinfo |
			sed 's/Local time zone must be set--see zic manual page/FCTY/' |
			docker_process_sql --dont-use-mysql-root-password --database=mysql
		# tell docker_process_sql to not use MYSQL_ROOT_PASSWORD since it is not set yet

		# mysql_tzinfo_to_sql /usr/share/zoneinfo | sed 's/Local time zone must be set--see zic manual page/FCTY/' | docker_process_sql --dont-use-mysql-root-password --database=mysql

	fi

	echo "docker_setup_db MYSQL_RANDOM_ROOT_PASSWORD: $MYSQL_RANDOM_ROOT_PASSWORD"
	# docker_setup_db MYSQL_RANDOM_ROOT_PASSWORD:
	# Generate random root password
	if [ -n "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
		MYSQL_ROOT_PASSWORD="$(openssl rand -base64 24)"
		export MYSQL_ROOT_PASSWORD
		mysql_note "GENERATED ROOT PASSWORD: $MYSQL_ROOT_PASSWORD"
	fi

	echo "docker_setup_db MYSQL_ROOT_HOST: $MYSQL_ROOT_HOST"
	# docker_setup_db MYSQL_ROOT_HOST: %
	# Sets root password and creates root users for non-localhost hosts
	local rootCreate=
	# default root to listen for connections from anywhere
	if [ -n "$MYSQL_ROOT_HOST" ] && [ "$MYSQL_ROOT_HOST" != 'localhost' ]; then
		# no, we don't care if read finds a terminating character in this heredoc
		# https://unix.stackexchange.com/questions/265149/why-is-set-o-errexit-breaking-this-read-heredoc-expression/265151#265151
		read -r -d '' rootCreate <<-EOSQL || true
			CREATE USER 'root'@'${MYSQL_ROOT_HOST}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
			GRANT ALL ON *.* TO 'root'@'${MYSQL_ROOT_HOST}' WITH GRANT OPTION ;
		EOSQL
	fi
	echo "docker_setup_db rootCreate: $rootCreate"
	# docker_setup_db rootCreate: CREATE USER 'root'@'%' IDENTIFIED BY 'my-secret-pw' ;
	# GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;

	local passwordSet=
	# no, we don't care if read finds a terminating character in this heredoc (see above)
	read -r -d '' passwordSet <<-EOSQL || true
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
	EOSQL
	echo "docker_setup_db passwordSet: $passwordSet"
	# docker_setup_db passwordSet: ALTER USER 'root'@'localhost' IDENTIFIED BY 'my-secret-pw' ;

	# tell docker_process_sql to not use MYSQL_ROOT_PASSWORD since it is just now being set
	docker_process_sql --dont-use-mysql-root-password --database=mysql <<-EOSQL
		-- enable autocommit explicitly (in case it was disabled globally)
		SET autocommit = 1;

		-- What's done in this file shouldn't be replicated
		--  or products like mysql-fabric won't work
		SET @@SESSION.SQL_LOG_BIN=0;

		${passwordSet}
		GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION ;
		FLUSH PRIVILEGES ;
		${rootCreate}
		DROP DATABASE IF EXISTS test ;
	EOSQL

	echo "docker_setup_db MYSQL_DATABASE: $MYSQL_DATABASE"
	# docker_setup_db MYSQL_DATABASE:
	# Creates a custom database and user if specified
	if [ -n "$MYSQL_DATABASE" ]; then
		mysql_note "Creating database ${MYSQL_DATABASE}"
		docker_process_sql --database=mysql <<<"CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;"
	fi

	echo "docker_setup_db MYSQL_USER: $MYSQL_USER"
	# docker_setup_db MYSQL_USER:
	echo "docker_setup_db MYSQL_PASSWORD: $MYSQL_PASSWORD"
	# docker_setup_db MYSQL_PASSWORD:
	if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
		mysql_note "Creating user ${MYSQL_USER}"
		docker_process_sql --database=mysql <<<"CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;"

		if [ -n "$MYSQL_DATABASE" ]; then
			mysql_note "Giving user ${MYSQL_USER} access to schema ${MYSQL_DATABASE}"
			docker_process_sql --database=mysql <<<"GRANT ALL ON \`${MYSQL_DATABASE//_/\\_}\`.* TO '$MYSQL_USER'@'%' ;"
		fi
	fi
}

_mysql_passfile() {
	# echo the password to the "file" the client uses
	# the client command will use process substitution to create a file on the fly
	# ie: --defaults-extra-file=<( _mysql_passfile )
	if [ '--dont-use-mysql-root-password' != "$1" ] && [ -n "$MYSQL_ROOT_PASSWORD" ]; then
		cat <<-EOF
			[client]
			password="${MYSQL_ROOT_PASSWORD}"
		EOF
	fi
}

# Mark root user as expired so the password must be changed before anything
# else can be done (only supported for 5.6+)
mysql_expire_root_user() {
	echo "mysql_expire_root_user MYSQL_ONETIME_PASSWORD: $MYSQL_ONETIME_PASSWORD"
	# mysql_expire_root_user MYSQL_ONETIME_PASSWORD:

	if [ -n "$MYSQL_ONETIME_PASSWORD" ]; then
		docker_process_sql --database=mysql <<-EOSQL
			ALTER USER 'root'@'%' PASSWORD EXPIRE;
		EOSQL
	fi
}

# _mysql_want_help mysqld
# check arguments for an option that would cause mysqld to stop
# return true if there is one
_mysql_want_help() {
	echo "_mysql_want_help @: $@"
	# _mysql_want_help @: mysqld

	local arg
	echo "_mysql_want_help arg: $arg"
	# _mysql_want_help arg:

	for arg; do
		echo "_mysql_want_help arg: $arg"
		# _mysql_want_help arg: mysqld

		case "$arg" in
		-'?' | --help | --print-defaults | -V | --version)
			return 0
			;;
		esac
	done
	return 1
}

_main() {
	echo "_main1 0: $0"
	echo "_main1 @: $@"
	# _main1 0: /usr/local/bin/docker-entrypoint.sh
	# _main1 @: mysqld

	# if command starts with an option, prepend mysqld
	if [ "${1:0:1}" = '-' ]; then
		set -- mysqld "$@"
	fi
	echo "_main2 0: $0"
	echo "_main2 @: $@"
	# _main2 0: /usr/local/bin/docker-entrypoint.sh
	# _main2 @: mysqld

	# skip setup if they aren't running mysqld or want an option that stops mysqld
	if [ "$1" = 'mysqld' ] && ! _mysql_want_help "$@"; then
		mysql_note "Entrypoint script for MySQL Server ${MYSQL_VERSION} started."

		mysql_check_config "$@"
		# Load various environment variables
		docker_setup_env "$@"
		docker_create_db_directories "$@"

		# If container is started as root user, restart as dedicated mysql user
		if [ "$(id -u)" = "0" ]; then
			mysql_note "Switching to dedicated user 'mysql'"
			exec gosu mysql "$BASH_SOURCE" "$@"
			# exec gosu mysql /usr/local/bin/docker-entrypoint.sh mysqld
		fi

		# there's no database, so it needs to be initialized
		if [ -z "$DATABASE_ALREADY_EXISTS" ]; then
			docker_verify_minimum_env

			# check dir permissions to reduce likelihood of half-initialized database
			ls /docker-entrypoint-initdb.d/ >/dev/null

			docker_init_database_dir "$@"

			mysql_note "Starting temporary server"
			docker_temp_server_start "$@"
			mysql_note "Temporary server started."

			mysql_socket_fix
			docker_setup_db
			docker_process_init_files /docker-entrypoint-initdb.d/*

			mysql_expire_root_user

			mysql_note "Stopping temporary server"
			docker_temp_server_stop
			mysql_note "Temporary server stopped"

			echo
			mysql_note "MySQL init process done. Ready for start up."
			echo
		else
			mysql_socket_fix
		fi
	fi
	set -x
	exec "$@"
	# exec mysqld
	set +x
}

echo "0: $0"
echo "@: $@"
# 0: /usr/local/bin/docker-entrypoint.sh
# @: mysqld

echo '------------------------'
env
echo '------------------------'
# ------------------------
# MYSQL_MAJOR=8.0
# HOSTNAME=a2bac462203e
# PWD=/
# MYSQL_ROOT_PASSWORD=my-secret-pw
# HOME=/root
# MYSQL_VERSION=8.0.37-1debian12
# GOSU_VERSION=1.17
# SHLVL=1
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# _=/usr/bin/env
# ------------------------

# + exec gosu mysql /usr/local/bin/docker-entrypoint.sh mysqld
# 0: /usr/local/bin/docker-entrypoint.sh
# @: mysqld
# ------------------------
# MYSQL_MAJOR=8.0
# HOSTNAME=9e6078be1db7
# PWD=/
# MYSQL_ROOT_PASSWORD=my-secret-pw
# MYSQL_PASSWORD=
# MYSQL_USER=
# HOME=/home/mysql
# MYSQL_VERSION=8.0.37-1debian12
# GOSU_VERSION=1.17
# MYSQL_ROOT_HOST=%
# SHLVL=1
# MYSQL_DATABASE=
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# _=/usr/bin/env
# ------------------------

# If we are sourced from elsewhere, don't perform any further actions
if ! _is_sourced; then
	_main "$@"
fi
