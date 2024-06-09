#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY="SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
         FROM elements
         INNER JOIN properties ON elements.atomic_number = properties.atomic_number
         INNER JOIN types ON properties.type_id = types.type_id
         WHERE elements.atomic_number = $1"
else
  QUERY="SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
         FROM elements
         INNER JOIN properties ON elements.atomic_number = properties.atomic_number
         INNER JOIN types ON properties.type_id = types.type_id
         WHERE elements.name = '$1' OR elements.symbol = '$1'"
fi

RESULT=$($PSQL "$QUERY")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo $RESULT | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi

