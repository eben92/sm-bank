package utils

import (
	"math/rand"
	"strings"
	"time"
)

var letters = "abcdefghijklmnopqrstuvwxyz"

func init() {
	source := rand.NewSource(time.Now().UnixNano())
	r := rand.New(source)
	_ = r
}

func RandomInt(min, max int64) int64 {
	return min + rand.Int63n(max-min+1)
}

func RandomString(n int) string {

	var sb strings.Builder
	s := len(letters)

	for i := 0; i < n; i++ {
		c := letters[rand.Intn(s)]
		sb.WriteByte(c)
	}

	return sb.String()
}

func RandomOwner() string {
	return RandomString(6)
}

func RandomMoney() int64 {
	return RandomInt(0, 1000)
}

func RandomCurrency() string {
	currencies := []string{"USD", "EUR", "CAD", "GHS"}
	n := len(currencies)

	return currencies[rand.Intn(n)]
}

func ConvertInt32To64(i int32) int64 {
	return int64(i)
}
