package main

import (
	"log"
	"os"
	"os/signal"
	"runtime"
	"syscall"
)

// import (
// 	"github.com/ardanlabs/conf"
// 	"github.com/dimfeld/httptreemux/v5"
// )

var build = "develop"

func main() {
	g := runtime.GOMAXPROCS(9)

	log.Printf("Starting service build[%s] CPU[%d]", build, g)
	defer log.Println(("Service ended"))
	shutdown := make(chan os.Signal, 1)
	signal.Notify(shutdown, syscall.SIGINT, syscall.SIGTERM)
	<-shutdown

	log.Println("Stopping service")
}
