package main

import (
	"net/http"
)

func main() {
	http.Handle("/metrics", prompt.Handler())
	http.ListenAndServe("2112", nil)
}
