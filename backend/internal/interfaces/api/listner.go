package api

import (
	"net"
)

func NewListener() (net.Listener, error) {
	return net.Listen("tcp", ":50051")
}
