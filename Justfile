set fallback
release VERSION:
    sed -i 's/0\.0\.0/{{VERSION}}/g' PklProject
    mkdir -p dist
    pkl project package --output-path dist

deps:
    mise install

test:
    pkl test
