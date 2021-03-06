FROM node:8.11.3-alpine
LABEL maintainer="Nguyen Nguyen <nguyenbk92@gmail.com>"
# Set the working directory to /app
WORKDIR /app
RUN  apk add --update \
    python \
    git \
    bash \
    make \
    g++

# Copy the current directory contents into the container at /app
COPY contracts /app/contracts/
COPY migrations /app/migrations
COPY test /app/test/
COPY truffle* /app/

CMD ["truffle", "compile"]
