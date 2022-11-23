package main

import (
	"fmt"
	"log"
	"os"
	"os/signal"
	"runtime"
	"syscall"

	"go.uber.org/automaxprocs/maxprocs"
)

// import (
// 	"github.com/ardanlabs/conf"
// 	"github.com/dimfeld/httptreemux/v5"
// )

var build = "develop"

func main() {
	// Set the correct number of threads for the service
	// based on what is available either by the machine or quotas
	if _, err := maxprocs.Set(); err != nil {
		fmt.Println("maxprocs: %w", err)
		os.Exit(1)
	}

	g := runtime.GOMAXPROCS(9)

	log.Printf("Starting service build[%s] CPU[%d]", build, g)
	defer log.Println(("Service ended"))
	shutdown := make(chan os.Signal, 1)
	signal.Notify(shutdown, syscall.SIGINT, syscall.SIGTERM)
	<-shutdown

	log.Println("Stopping service")
}
