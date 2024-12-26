release VERSION:
    sed -i 's/0\.0\.0/{{VERSION}}/g' filename
    mkdir -p dist
    pkl project package --output-path dist

test:
    pkl test