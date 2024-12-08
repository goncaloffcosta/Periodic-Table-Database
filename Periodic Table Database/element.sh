#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Determine the type of input and adjust the query accordingly
if [[ $1 =~ ^[0-9]+$ ]]; then
  QUERY="SELECT elements.atomic_number, elements.name, elements.symbol, types.type,
                properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
         FROM elements
         JOIN properties ON elements.atomic_number = properties.atomic_number
         JOIN types ON properties.type_id = types.type_id
         WHERE elements.atomic_number = $1;"
elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]; then
  QUERY="SELECT elements.atomic_number, elements.name, elements.symbol, types.type,
                properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
         FROM elements
         JOIN properties ON elements.atomic_number = properties.atomic_number
         JOIN types ON properties.type_id = types.type_id
         WHERE elements.symbol = '$1';"
else
  QUERY="SELECT elements.atomic_number, elements.name, elements.symbol, types.type,
                properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
         FROM elements
         JOIN properties ON elements.atomic_number = properties.atomic_number
         JOIN types ON properties.type_id = types.type_id
         WHERE elements.name ILIKE '$1';"
fi

# Execute the query
RESULT=$($PSQL "$QUERY")

if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
fi