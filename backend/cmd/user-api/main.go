package main

import (
	"log"

	"github.com/scizorman/aws-playground/backend/internal/interfaces/api"
	"github.com/scizorman/aws-playground/backend/internal/interfaces/api/user"
)

func main() {
	l, err := api.NewListener()
	if err != nil {
		log.Fatal(err)
	}
	userAPIServer := user.NewUserAPIServer()
	s := user.NewServer(userAPIServer)
	if err := s.Serve(l); err != nil {
		log.Fatal(err)
	}
}
