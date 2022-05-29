FROM golang:alpine
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN go mod init
RUN go build -o main . 
CMD ["/app/main"]


# Create build stage based on buster image
FROM golang:alpine

# Create working directory under /app
WORKDIR /app

# Copy over all go config (go.mod, go.sum etc.)
COPY go.* ./

# Install any required modules
RUN go mod download

# Copy over Go source code
COPY *.go ./

# Run the Go build and output binary under hello_go_http
RUN go build -o /remote

# Make sure to expose the port the HTTP server is using
EXPOSE 8080

# Run the app binary when we run the container
ENTRYPOINT ["/remote"]
