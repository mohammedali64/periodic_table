PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

INPUT=$1

# Query depending on number / symbol / name
if [[ $INPUT =~ ^[0-9]+$ ]]
then
  RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
  FROM elements e 
  JOIN properties p USING(atomic_number) 
  JOIN types t USING(type_id) 
  WHERE e.atomic_number=$INPUT")
else
  RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
  FROM elements e 
  JOIN properties p USING(atomic_number) 
  JOIN types t USING(type_id) 
  WHERE lower(e.symbol)=lower('$INPUT') OR lower(e.name)=lower('$INPUT')")
fi

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi