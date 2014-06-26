package main

import (
	"log"

	"github.com/snowplow/referer-parser/go"
)

func main() {
	referer_url := "http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari"
	r := refererparser.Parse(referer_url)

	log.Printf("Known:%v", r.Known)
	log.Printf("Referer:%v", r.Referer)
	log.Printf("Medium:%v", r.Medium)
	log.Printf("Search parameter:%v", r.SearchParameter)
	log.Printf("Search term:%v", r.SearchTerm)
	log.Printf("Host:%v", r.URI)
}
