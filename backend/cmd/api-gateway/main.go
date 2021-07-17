package main

import (
	"log"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"google.golang.org/grpc"

	pb "github.com/scizorman/aws-playground/backend/internal/interfaces/rpc/user"
)

func main() {
	conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure())
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()
	h := &userHandler{
		userAPIClient: pb.NewUserAPIClient(conn),
	}

	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.GET("/users/:id", h.getUser)

	e.Logger.Fatal(e.Start(":3030"))
}

type userHandler struct {
	userAPIClient pb.UserAPIClient
}

func (h *userHandler) getUser(c echo.Context) error {
	userID := c.Param("id")
	ctx := c.Request().Context()
	in := &pb.GetUserRequest{UserId: userID}
	out, err := h.userAPIClient.GetUser(ctx, in)
	if err != nil {
		return err
	}
	u := map[string]interface{}{
		"id":           out.User.GetId(),
		"email":        out.User.GetEmail(),
		"username":     out.User.GetUsername(),
		"display_name": out.User.GetDisplayName(),
	}
	return c.JSON(http.StatusOK, u)
}
