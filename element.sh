#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

SYMBOL=$1

MAIN_MENU() {
  if [[ $SYMBOL = "" ]]
  then
    echo Please provide an element as an argument.
  else
    GET_ALL_DATA
  fi
}

GET_ALL_DATA() {
  if [[ $SYMBOL =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $SYMBOL ")
    ELEMENT_NAME=$($PSQL "SELECT elements.name FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $SYMBOL ")
    ELEMENT_SYMBOL=$($PSQL "SELECT elements.symbol FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $SYMBOL ")
    PROPERTY_TYPE=$($PSQL "SELECT types.type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $SYMBOL ")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $SYMBOL ")
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $SYMBOL ")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $SYMBOL ")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.name = '$SYMBOL' OR elements.symbol = '$SYMBOL'")
    ELEMENT_NAME=$($PSQL "SELECT elements.name FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.name = '$SYMBOL' OR elements.symbol = '$SYMBOL'")
    ELEMENT_SYMBOL=$($PSQL "SELECT elements.symbol FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.name = '$SYMBOL' OR elements.symbol = '$SYMBOL'")
    PROPERTY_TYPE=$($PSQL "SELECT types.type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.name = '$SYMBOL' OR elements.symbol = '$SYMBOL'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.name = '$SYMBOL' OR elements.symbol = '$SYMBOL'")
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.name = '$SYMBOL' OR elements.symbol = '$SYMBOL'")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.name = '$SYMBOL' OR elements.symbol = '$SYMBOL'")
  fi
  if [[ $ELEMENT_NAME != "" ]]
  then
    PROMPT_RESULT="The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $PROPERTY_TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    echo $PROMPT_RESULT
  else
    echo I could not find that element in the database.
  fi  

}

MAIN_MENU
