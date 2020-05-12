#!/bin/bash
#Setup arguments
script_execute=$1
PGUSER=$2
PGPASSWORD=$3

#Main code
#check if docker_deamon is running - otherwise start
systemctl status docker || systemctl start docker

#check if user wants to create new psql table
if [ $script_execute== "create" ]; then
  #list all docker containers and filter for jrvs-psql and then counts words in name
  if  [ "$(docker ps -a -f name=jrvs-psql | wc -l)" == "2" ]; then
    echo "Error: Container already exists"
    exit 1

  elif [ "$#" != 3 ]; then
    echo "Error: database username or password not passed"
    exit 1

  else
    docker pull postgres
    docker volume create pgdata

    docker run --name jrvs-psql -e POSTGRES_PASSWORD=$PGPASSWORD \
    -e POSTGRES_USER=$PGUSER -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
    exit $?
    fi

else
  if [ "$(docker ps -a -f name=jrvs-psql | wc -l)" != "2" ]; then
    echo "Error: Container does not exist"
    exit 1
    fi

  if [ $script_execute == "start" ]; then
    docker container start jrvs-psql
    exit $?

  elif [ $script_execute == "stop" ]; then
    docker container stop jrvs-psql
    exit $?

  else
    echo "Error: Invlaid argument"
    exit 1
    fi
  fi