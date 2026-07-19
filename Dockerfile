FROM golang:1.22.5 as base 

WORKDIR /app

COPY go.mod .

# incase there are dependencies, download them first 
RUN go mod download 

COPY . .

RUN go build -o main.exe .

#After this can directly do EXPOSE 8080 and run CMD["./main.exe"] but goal is to reduce docker image size 

#Final stage - Distroless image 

FROM gcr.io/distroless/base

#Copy the binary from first stage 

COPY --from=base /app/main.exe .

COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main.exe"]


