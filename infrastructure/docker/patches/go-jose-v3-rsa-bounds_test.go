package jose

import (
	"crypto/rand"
	"crypto/rsa"
	"encoding/json"
	"math/big"
	"strings"
	"testing"
)

// Exercise the public JSON boundary, including JWKs nested in a JWKS. These
// inputs must be rejected before crypto/rsa performs private-key validation.
func TestMateryalRejectsUnsafeRSAParameters(t *testing.T) {
	normal := new(big.Int).Lsh(big.NewInt(1), 2047).Bytes()
	oversized := new(big.Int).Lsh(big.NewInt(1), 4096).Bytes()
	for _, test := range []struct {
		name string
		key  rawJSONWebKey
		want string
	}{
		{"large public modulus", rawJSONWebKey{N: newBuffer(oversized), E: newBuffer([]byte{3})}, "modulus too large"},
		{"large private modulus", rawJSONWebKey{N: newBuffer(oversized), E: newBuffer([]byte{3}), D: newBuffer([]byte{1}), P: newBuffer([]byte{2}), Q: newBuffer([]byte{3})}, "modulus too large"},
		{"oversized primes", rawJSONWebKey{N: newBuffer(normal), E: newBuffer([]byte{3}), D: newBuffer([]byte{1}), P: newBuffer(oversized), Q: newBuffer(oversized)}, "p * q != n"},
		{"inconsistent primes", rawJSONWebKey{N: newBuffer(normal), E: newBuffer([]byte{3}), D: newBuffer([]byte{1}), P: newBuffer([]byte{2}), Q: newBuffer([]byte{3})}, "p * q != n"},
		{"zero primes", rawJSONWebKey{N: newBuffer(normal), E: newBuffer([]byte{3}), D: newBuffer([]byte{1}), P: newBuffer([]byte{0}), Q: newBuffer([]byte{0})}, "p * q != n"},
	} {
		t.Run(test.name, func(t *testing.T) {
			test.key.Kty = "RSA"
			encoded, err := json.Marshal(test.key)
			if err != nil {
				t.Fatal(err)
			}
			for _, jwks := range []bool{false, true} {
				var target interface{} = &JSONWebKey{}
				input := encoded
				if jwks {
					target = &JSONWebKeySet{}
					input = append(append([]byte(`{"keys":[`), encoded...), []byte(`]}`)...)
				}
				if err := json.Unmarshal(input, target); err == nil || !strings.Contains(err.Error(), test.want) {
					t.Fatalf("jwks=%t: expected %q, got %v", jwks, test.want, err)
				}
			}
		})
	}
}

func TestMateryalAcceptsValidRSAKeys(t *testing.T) {
	private, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatal(err)
	}
	for _, key := range []interface{}{private, &private.PublicKey} {
		encoded, err := json.Marshal(JSONWebKey{Key: key})
		if err != nil {
			t.Fatal(err)
		}
		var decoded JSONWebKey
		if err := json.Unmarshal(encoded, &decoded); err != nil {
			t.Fatal(err)
		}
		if !decoded.Valid() || decoded.IsPublic() != (key == &private.PublicKey) {
			t.Fatal("valid RSA key did not round trip")
		}
	}
}
