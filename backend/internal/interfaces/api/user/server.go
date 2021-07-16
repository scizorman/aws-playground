package user

import (
	grpc_recovery "github.com/grpc-ecosystem/go-grpc-middleware/recovery"
	"google.golang.org/grpc"

	pb "github.com/scizorman/aws-playground/backend/internal/interfaces/rpc/user"
)

func NewServer(userAPIServer pb.UserAPIServer) *grpc.Server {
	s := grpc.NewServer(grpc.UnaryInterceptor(grpc_recovery.UnaryServerInterceptor()))
	pb.RegisterUserAPIServer(s, userAPIServer)
	return s
}
