package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.GET("/", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{"message": "OK!"})
	})

	userHandler := NewUserHandler()
	e.GET("/users/:id", userHandler.GetUser)

	port := os.Getenv("SERVER_PORT")
	addr := fmt.Sprintf(":%s", port)
	if err := e.Start(addr); err != nil {
		e.Logger.Fatal(err)
	}
}

type User struct {
	ID          string `json:"id"`
	Username    string `json:"username"`
	DisplayName string `json:"display_name"`
	Bio         string `json:"bio,omitempty"`
}

type UserHandler interface {
	GetUser(c echo.Context) error
}

func NewUserHandler() UserHandler {
	return &userHandler{}
}

type userHandler struct{}

func (h *userHandler) GetUser(c echo.Context) error {
	id := c.Param("id")
	u := &User{
		ID:          id,
		Username:    "scizorman",
		DisplayName: "Tetsutaro Ueda",
	}
	return c.JSON(http.StatusOK, u)
}
