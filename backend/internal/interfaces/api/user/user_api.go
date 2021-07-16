package user

import (
	"context"

	pb "github.com/scizorman/aws-playground/backend/internal/interfaces/rpc/user"
)

func NewUserAPIServer() pb.UserAPIServer {
	return &userAPIServer{}
}

type userAPIServer struct{}

func (s *userAPIServer) GetUser(ctx context.Context, in *pb.GetUserRequest) (*pb.GetUserResponse, error) {
	return &pb.GetUserResponse{
		User: &pb.User{
			Id:          in.GetUserId(),
			Email:       "scizorman@gmail.com",
			Username:    "scizorman",
			DisplayName: "Tetsutaro Ueda",
		},
	}, nil
}
