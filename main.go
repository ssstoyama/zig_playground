package main

import (
	"log"
)

func main() {
	add := func(x, y int) int {
		return x+y
	}

	log.Printf("2+3=%d\n", add(2, 3))
}