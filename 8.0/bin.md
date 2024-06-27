```bash
# /usr/bin/myisam_ftdump
# /usr/bin/mysql_config_editor
# /usr/bin/mysqladmin
# /usr/bin/mysqlcheck
# /usr/bin/mysqldumpslow
# /usr/bin/mysqlimport
# /usr/bin/mysqlshow
# /usr/bin/mysqlslap
# /usr/bin/mysql
# /usr/bin/mysqldump
# /usr/bin/mysqlpump
# /usr/bin/ibd2sdi
# /usr/bin/innochecksum
# /usr/bin/lz4_decompress
# /usr/bin/my_print_defaults
# /usr/bin/myisamchk
# /usr/bin/myisamlog
# /usr/bin/myisampack
# /usr/bin/mysql_migrate_keyring
# /usr/bin/mysql_secure_installation
# /usr/bin/mysql_ssl_rsa_setup
# /usr/bin/mysql_tzinfo_to_sql
# /usr/bin/mysql_upgrade
# /usr/bin/mysqlbinlog
# /usr/bin/mysqld_multi
# /usr/bin/mysqld_safe
# /usr/bin/perror
# /usr/bin/zlib_decompress
# /usr/sbin/mysqld

######################################################################

$ mysqld --verbose --help | more
mysqld  Ver 8.0.37 for Linux on x86_64 (MySQL Community Server - GPL)
BuildID[sha1]=3add7c01e5f3ed221a9b0a1e0aa7785e5f82af3a
Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Starts the MySQL database server.

Usage: mysqld [OPTIONS]

Default options are read from the following files in the given order:
/etc/my.cnf /etc/mysql/my.cnf ~/.my.cnf
The following groups are read: mysql_cluster mysqld server mysqld-8.0
The following options may be given as the first argument:
--print-defaults        Print the program argument list and exit.
--no-defaults           Don't read default options from any option file,
                        except for login file.
--defaults-file=#       Only read default options from the given file #.
--defaults-extra-file=# Read this file after the global files are read.
--defaults-group-suffix=#
                        Also read groups with concat(group, suffix)
--login-path=#          Read this path from the login file.
...

######################################################################

$ cat /usr/bin/mysqld_safe
#!/bin/sh
# Copyright Abandoned 1996 TCX DataKonsult AB & Monty Program KB & Detron HB
# This file is public domain and comes with NO WARRANTY of any kind
#
# Script to start the MySQL daemon and restart it if it dies unexpectedly
#
# This should be executed in the MySQL base directory if you are using a
# binary installation that is not installed in its compile-time default
# location
#
# mysql.server works by first doing a cd to the base directory and from there
# executing mysqld_safe

# Initialize script globals
KILL_MYSQLD=1;
MYSQLD=
niceness=0
mysqld_ld_preload=
mysqld_ld_library_path=

######################################################################

$ cat /usr/bin/mysqld_multi | more
#!/usr/bin/perl

# Copyright (c) 2000, 2024, Oracle and/or its affiliates.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2.0,
# as published by the Free Software Foundation.
#
# This program is designed to work with certain software (including
# but not limited to OpenSSL) that is licensed under separate terms,
# as designated in a particular file or component or in included license
# documentation.  The authors of MySQL hereby grant you an additional
# permission to link the program and your derivative works with the
# separately licensed software that they have either included with
# the program or referenced in the documentation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License, version 2.0, for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA

use Getopt::Long;
use POSIX qw(strftime getcwd);
use File::Path qw(mkpath);

$|=1;
$VER="2.16";

my @defaults_options;   #  Leading --no-defaults, --defaults-file, etc.

$opt_example       = 0;
$opt_help          = 0;
$opt_log           = undef();
$opt_mysqladmin    = "/usr/bin/mysqladmin";
$opt_mysqld        = "/usr/sbin/mysqld";
$opt_no_log        = 0;
$opt_password      = undef();
$opt_tcp_ip        = 0;
$opt_user          = "root";
...


```
