#!/usr/bin/env bash

# Paths
PATH_REMOTE="/usr/share/remarkable/templates"
PATH_LOCAL="."

# Templates
TEMPLATE_1o1="x_1o1.png"
TEMPLATE_checklist="x_checklist.png"
TEMPLATE_standup="x_standup.png"
TEMLPATES_JSON_ORIGINAL="templates.json.original"
TEMLPATES_JSON_ADDITION="templates.json.addition"
TEMLPATES_JSON_REAL="templates.json"

helpFunction()
{
   echo ""
   echo "Usage: $0 -i remarkableIP"
   echo -e "\t-i IP of the remarkable2 device"
   echo ""
   echo "To get the device IP, visit Settings > General > Help > Copyrights and licenses"
   echo ""
   exit 1 # Exit script after printing help
}

while getopts "i:" opt
do
   case "$opt" in
      i ) remarkableIP="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$remarkableIP" ]
then
   echo "The required parameter is empty";
   helpFunction
fi

# Now we begin
echo ""
echo "Will copy templates from $PATH_LOCAL to root@$remarkableIP:$PATH_REMOTE"
echo ""
printf 'Are you sure (y/n)? '
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then 
    echo "Starting..."
    # Doing it in this way so we only accept "Yy" and the rest just exits
else
    echo "Doing nothing."
    exit 0
fi

echo "Copying template 1: $TEMPLATE_1o1"
scp "$PATH_LOCAL/$TEMPLATE_1o1" "root@$remarkableIP:$PATH_REMOTE/."

echo "Copying template 2: $TEMPLATE_checklist"
scp "$PATH_LOCAL/$TEMPLATE_checklist" "root@$remarkableIP:$PATH_REMOTE/."

echo "Copying template 3: $TEMPLATE_standup"
scp "$PATH_LOCAL/$TEMPLATE_standup" "root@$remarkableIP:$PATH_REMOTE/."

echo "Getting the template JSON file"
scp "root@$remarkableIP:$PATH_REMOTE/$TEMLPATES_JSON_REAL" "$PATH_LOCAL/$TEMLPATES_JSON_ORIGINAL"

echo "Adding the templates config into the JSON FILE"
sed -e "2r $TEMLPATES_JSON_ADDITION" "$TEMLPATES_JSON_ORIGINAL" > "$TEMLPATES_JSON_REAL"

echo "Validate the JSON"
VALIDATION=$(cat "$TEMLPATES_JSON_REAL" | python -c "import sys,json;json.loads(sys.stdin.read());print(\"OK\")")

if [ "$VALIDATION" != "OK" ] ;then
    echo "The JSON is invalid. Stopping here. Please debug."
    exit 1
fi

echo "Copying back the templates config into the device"
scp "$PATH_LOCAL/$TEMLPATES_JSON_REAL" "root@$remarkableIP:$PATH_REMOTE/."

echo "Cleaning up"
rm "$TEMLPATES_JSON_ORIGINAL"
rm "$TEMLPATES_JSON_REAL"
