#!/bin/bash

# Directory containing the CSV files
CSV_DIR=~/tmp/query_csv

# Find the most recent CSV file
LATEST_FILE=$(ls -t $CSV_DIR/*.csv 2>/dev/null | head -n 1)

if [ -z "$LATEST_FILE" ]; then
    echo "No CSV files found in $CSV_DIR"
    exit 1
fi

echo "Processing file: $LATEST_FILE"

# Create a temporary file
TEMP_FILE=$(mktemp)

# Start building the SQL query
echo "SET FOREIGN_KEY_CHECKS = 0;" > "$TEMP_FILE"
echo "" >> "$TEMP_FILE"

# Read the header to get column names
HEADER=$(head -n 1 "$LATEST_FILE")
IFS=',' read -ra COLUMNS <<< "$HEADER"

# Get the table name from the file name
TABLE_NAME=$(basename "$LATEST_FILE" .csv)

# Start the INSERT statement
echo "INSERT INTO ${TABLE_NAME} (" >> "$TEMP_FILE"

# Add column names
for i in "${!COLUMNS[@]}"; do
    # Add 4 spaces for indentation
    echo -n "    " >> "$TEMP_FILE"
    
    # Add the column name
    echo -n "${COLUMNS[$i]}" >> "$TEMP_FILE"
    
    # Add comma after each column except the last one
    if [ $i -lt $((${#COLUMNS[@]} - 1)) ]; then
        echo "," >> "$TEMP_FILE"
    else
        echo "" >> "$TEMP_FILE"
    fi
done

echo ") VALUES" >> "$TEMP_FILE"

# Process the data rows, skipping the header
FIRST_ROW=true
tail -n +2 "$LATEST_FILE" | while IFS= read -r line; do
    # Initialize the values array
    values=()
    
    # Process the line to handle JSON and other complex data
    current_field=""
    in_quotes=false
    in_json=false
    json_brace_count=0
    
    # Process each character in the line
    for (( i=0; i<${#line}; i++ )); do
        char="${line:$i:1}"
        next_char="${line:$i+1:1}"
        
        # Handle quote state
        if [ "$char" = '"' ] && [ "$in_json" = false ]; then
            if [ "$in_quotes" = true ]; then
                # Check if this is an escaped quote
                if [ "$next_char" = '"' ]; then
                    current_field+=$char
                    ((i++))  # Skip the next quote
                else
                    in_quotes=false
                fi
            else
                in_quotes=true
            fi
            current_field+=$char
            continue
        fi
        
        # Handle JSON objects
        if [ "$char" = '{' ] && ([ "$in_quotes" = true ] || [ "$in_json" = true ]); then
            if [ "$in_json" = false ]; then
                in_json=true
            fi
            ((json_brace_count++))
            current_field+=$char
            continue
        fi
        
        if [ "$char" = '}' ] && [ "$in_json" = true ]; then
            ((json_brace_count--))
            current_field+=$char
            if [ $json_brace_count -eq 0 ]; then
                in_json=false
            fi
            continue
        fi
        
        # Handle field separator (comma)
        if [ "$char" = ',' ] && [ "$in_quotes" = false ] && [ "$in_json" = false ]; then
            # Process the completed field
            if [ "$current_field" = "<nil>" ]; then
                values+=("NULL")
            elif [[ $current_field =~ ^[0-9]+$ || $current_field =~ ^[0-9]+\.[0-9]+$ ]]; then
                values+=("$current_field")
            elif [[ $current_field =~ ^\".*\"$ ]]; then
                # Already quoted string, just escape single quotes inside
                processed_field=$(echo "$current_field" | sed "s/'/''/g")
                values+=("$processed_field")
            else
                # Add quotes for non-numeric values
                processed_field=$(echo "$current_field" | sed "s/'/''/g")
                values+=("'$processed_field'")
            fi
            current_field=""
            continue
        fi
        
        # Add character to current field
        current_field+=$char
        
        # Handle the last field in the line
        if [ $i -eq $((${#line} - 1)) ]; then
            if [ "$current_field" = "<nil>" ]; then
                values+=("NULL")
            elif [[ $current_field =~ ^[0-9]+$ || $current_field =~ ^[0-9]+\.[0-9]+$ ]]; then
                values+=("$current_field")
            elif [[ $current_field =~ ^\".*\"$ ]]; then
                # Already quoted string, just escape single quotes inside
                processed_field=$(echo "$current_field" | sed "s/'/''/g")
                values+=("$processed_field")
            else
                # Add quotes for non-numeric values
                processed_field=$(echo "$current_field" | sed "s/'/''/g")
                values+=("'$processed_field'")
            fi
        fi
    done
    
    # Format the values for SQL
    formatted_values=$(printf ", %s" "${values[@]}")
    formatted_values=${formatted_values:2}  # Remove leading comma and space
    
    # Add the row to the SQL statement
    if [ "$FIRST_ROW" = true ]; then
        echo "    (${formatted_values})" >> "$TEMP_FILE"
        FIRST_ROW=false
    else
        echo "    ,(${formatted_values})" >> "$TEMP_FILE"
    fi
done

# Add ON DUPLICATE KEY UPDATE clause
echo "ON DUPLICATE KEY UPDATE" >> "$TEMP_FILE"

# Add all columns except id and created_at
FIRST_COL=true
for col in "${COLUMNS[@]}"; do
    if [[ "$col" != "id" && "$col" != "created_at" ]]; then
        if [ "$FIRST_COL" = true ]; then
            echo "    ${col} = VALUES(${col})" >> "$TEMP_FILE"
            FIRST_COL=false
        else
            echo "    ,${col} = VALUES(${col})" >> "$TEMP_FILE"
        fi
    fi
done

echo ";" >> "$TEMP_FILE"
echo "" >> "$TEMP_FILE"

# Add query to update empty strings to NULL for currency
echo "UPDATE ${TABLE_NAME} SET currency = NULL WHERE currency = '';" >> "$TEMP_FILE"

# Create a new file with the same name but with .sql extension
OUTPUT_FILE="${LATEST_FILE%.csv}.sql"

# Copy the formatted SQL to the output file
cat "$TEMP_FILE" > "$OUTPUT_FILE"

# Output to stdout and copy to clipboard
cat "$TEMP_FILE" | tee >(pbcopy)

# Clean up
rm "$TEMP_FILE"

echo "Complete SQL query has been copied to clipboard!"
echo "Complete SQL query has been saved to $OUTPUT_FILE"
