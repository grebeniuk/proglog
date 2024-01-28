package main

import (
	"log"

	"github.com/grebeniuk/proglog/internal/server"
)

func main() {
	srv := server.NewHTTPServer(":8082")
	log.Fatal(srv.ListenAndServe())
}
