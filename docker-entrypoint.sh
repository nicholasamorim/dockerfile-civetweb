#!/bin/sh
set -e

exec "$@" -run_as_user civetweb
