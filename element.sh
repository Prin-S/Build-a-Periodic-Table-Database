#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

# Check if there's no argument provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # If a number is entered
  if [[ $1 =~ [0-9]+ ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $1")
  # If a symbol is entered
  elif [[ ! $1 =~ [0-9]+ && $1 =~ ^.{1,2}$ ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol = '$1'")
  # If a name is entered
  else
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE name = '$1'")
  fi

  # Check if a non-existent element is entered
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    # Output full sentences with info about entered element
    echo $ELEMENT | while read TYPE_ID PIPE NUMBER PIPE SYMBOL PIPE NAME PIPE MASS PIPE MELTING PIPE BOILING PIPE TYPE
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi

