package main

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/time", getTimeHandler).Methods("GET")
	_ = http.ListenAndServe(":8080", r)
}

func getTimeHandler(w http.ResponseWriter, r *http.Request) {
	type timeResponse struct {
		CurrentTime string `json:"current_time"`
	}

	w.Header().Set("Content-Type", "application/json")
	currentTime := time.Now().Format(time.RFC3339)
	json.NewEncoder(w).Encode(timeResponse{CurrentTime: currentTime})
}
