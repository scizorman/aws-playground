package main

import (
	"context"
	"log"

	"google.golang.org/grpc"

	pb "github.com/scizorman/aws-playground/backend/internal/interfaces/rpc/user"
)

func main() {
	conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure())
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	c := pb.NewUserAPIClient(conn)
	ctx := context.Background()
	in := &pb.GetUserRequest{UserId: "705087ed-4c95-4ed2-9706-77b363a1e9c9"}
	out, err := c.GetUser(ctx, in)
	if err != nil {
		log.Fatal(err)
	}
	log.Println(out)
}
